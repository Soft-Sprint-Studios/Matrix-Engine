#ifndef PNG_H
#define PNG_H

#include "includes.h"  // Include necessary headers
#include <cstdint>    // For stdint data types
#include "texturemanager.h"
#include "stb/stb_image.h"  // Include the stb_image library header

// Function prototype for PNG_Load
//=============================================
// @brief Loads a PNG file and returns its data
//
// @param pstrFilename Path to the PNG file
// @param pdata Destination pointer for image data
// @param width Reference to texture width variable
// @param height Reference to texture height variable
// @param bpp Reference to texture bit depth variable
// @param size Reference to data size variable
// @return TRUE if successfully loaded, FALSE otherwise
//=============================================
bool PNG_Load(const Char* pstrFilename, byte*& pdata, Uint32& width, Uint32& height, Uint32& bpp, Uint32& size, pfnPrintf_t pfnPrintFn);

#endif // PNG_H
