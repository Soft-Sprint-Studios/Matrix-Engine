#include "png.h"

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
bool PNG_Load(const Char* pstrFilename, byte*& pdata, Uint32& width, Uint32& height, Uint32& bpp, Uint32& size, pfnPrintf_t pfnPrintFn)
{
    // Declare pointers for the width, height, and channels (bit depth)
    int imgWidth, imgHeight, channels;

    // Load the image using stb_image
    pdata = reinterpret_cast<byte*>(stbi_load(pstrFilename, &imgWidth, &imgHeight, &channels, 4));

    // Check if the image was loaded successfully
    if (!pdata) {
        pfnPrintFn("Failed to load PNG file: %s.\n", pstrFilename);
        return false;
    }

    // Set the output values
    width = imgWidth;
    height = imgHeight;
    bpp = 4;  // STB loads the image data as 4 channels (RGBA)
    size = imgWidth * imgHeight * bpp;

    // Return true indicating successful loading
    return true;
}
