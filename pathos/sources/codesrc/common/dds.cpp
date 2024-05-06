/*
===============================================
Pathos Engine - Created by Andrew Stephen "Overfloater" Lucas

Copyright 2016
All Rights Reserved.
===============================================
*/

#include "includes.h"
#include "texturemanager.h"
#include "dds.h"

//=============================================
// @brief Loads a DDS file and returns it's data
//
// @param pfile Pointer to raw file data
// @param pdata Destination pointer for image data
// @param width Reference to texture width variable
// @param height Reference to texture height variable
// @param bpp Reference to texture bit depth variable
// @param size Reference to data size variable
// @param compression Reference to texture compression variable
// @return TRUE if successfully loaded, FALSE otherwise
//=============================================
bool DDS_Load( const Char* pstrFilename, const byte* pfile, byte*& pdata, Uint32& width, Uint32& height, Uint32& bpp, Uint32& size, texture_compression_t& compression, pfnPrintf_t pfnPrintFn )
{
	const dds_header_t *pDDSHeader = reinterpret_cast<const dds_header_t*>(pfile);

	// Read information
	Uint32 ddsFlags = Common::ByteToUint32(pDDSHeader->bFlags);
	Uint32 ddsMagic = Common::ByteToUint32(pDDSHeader->bMagic);
	Uint32 ddsFourCC = Common::ByteToUint32(pDDSHeader->bPFFourCC);
	Uint32 ddsPFFlags = Common::ByteToUint32(pDDSHeader->bPFFlags);
	Uint32 ddsLinSize = Common::ByteToUint32(pDDSHeader->bPitchOrLinearSize);
	Uint32 ddsSize = Common::ByteToUint32(pDDSHeader->bSize);

	Uint32 ddsWidth = Common::ByteToUint32(pDDSHeader->bWidth);
	Uint32 ddsHeight = Common::ByteToUint32(pDDSHeader->bHeight);

	if(!Common::IsPowerOfTwo(ddsWidth) || !Common::IsPowerOfTwo(ddsHeight))
	{
		pfnPrintFn("%s is not a power of two texture.\n", pstrFilename);
		return false;
	}
		
	if(ddsMagic != DDS_MAGIC || ddsSize != 124 || !(ddsFlags & DDSD_PIXELFORMAT)
		|| !(ddsFlags & DDSD_CAPS) || !(ddsPFFlags & DDPF_FOURCC))
	{
		pfnPrintFn("Incorrect DDS format on %s.\n", pstrFilename);
		return false;
	}

	if (ddsFourCC == D3DFMT_DXT1) {
		compression = TX_COMPRESSION_DXT1;
	}
	else if (ddsFourCC == D3DFMT_DXT3) {
		compression = TX_COMPRESSION_DXT3;
	}
	else if (ddsFourCC == D3DFMT_DXT5 || ddsFourCC == D3DFMT_BC3) {
		compression = TX_COMPRESSION_DXT5;
	}
	else if (ddsFourCC == D3DFMT_BC7) {
		compression = TX_COMPRESSION_BC7;
	}
	else if (ddsFourCC == D3DFMT_BC1) {
		compression = TX_COMPRESSION_BC1;
	}
	else if (ddsFourCC == D3DFMT_BC4 || ddsFourCC == D3DFMT_ATI1) {
		compression = TX_COMPRESSION_BC4;
	}
	else if (ddsFourCC == D3DFMT_BC5 || ddsFourCC == D3DFMT_ATI2) {
		compression = TX_COMPRESSION_BC5;
	}
	else if (ddsFourCC == D3DFMT_BC6H) {
		compression = TX_COMPRESSION_BC6H;
	}
	else if (ddsFourCC == D3DFMT_DXT2) {
		compression = TX_COMPRESSION_DXT2;  // Add handling for DXT2
	}
	else if (ddsFourCC == D3DFMT_DXT4) {
		compression = TX_COMPRESSION_DXT4;  // Add handling for DXT4
	}
	else if (ddsFourCC == D3DFMT_A8R8G8B8) {
		compression = TX_COMPRESSION_A8R8G8B8;
	}
	else if (ddsFourCC == D3DFMT_R8G8B8) {
		compression = TX_COMPRESSION_R8G8B8;
	}
	else {
		pfnPrintFn("Incorrect compression on: %s. Supported formats are DXT1, DXT2, DXT3, DXT4, DXT5, BC7, BC1, BC4, BC5, BC6H, A8R8G8B8, and R8G8B8 DDS files.\n", pstrFilename);
		return false;
	}

	// Set output data
	width = ddsWidth;
	height = ddsHeight;
	size = ddsLinSize;
	bpp = 4;

	// Copy data
	pdata = new byte[ddsLinSize];
	memcpy(pdata, (pfile + DDS_DATA_OFFSET), ddsLinSize);

	return true;
}