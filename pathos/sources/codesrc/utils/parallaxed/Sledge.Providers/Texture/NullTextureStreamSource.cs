using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Threading.Tasks;

namespace Sledge.Providers.Texture
{
    public class NullTextureStreamSource : ITextureStreamSource
    {
        public bool HasImage(string item)
        {
            return true;
        }

        public Task<Bitmap> GetProcessedImage(string item, int maxWidth, int maxHeight)
        {
            return Task.Factory.StartNew(() =>
            {
                Bitmap bitmap = new Bitmap(16, 16, PixelFormat.Format32bppArgb);
                BitmapData bitmapData = bitmap.LockBits(new Rectangle(0, 0, bitmap.Width, bitmap.Height), ImageLockMode.WriteOnly, bitmap.PixelFormat);
                int bytesPerPixel = Bitmap.GetPixelFormatSize(bitmap.PixelFormat) / 8;
                int byteCount = bitmapData.Stride * bitmap.Height;
                byte[] pixels = new byte[byteCount];

                // Generate image data
                int index = 0;
                for (int y = 0; y < bitmap.Height; y++)
                {
                    for (int x = 0; x < bitmap.Width; x++)
                    {
                        byte red, green, blue, alpha;
                        if ((y < 8) ^ (x < 8))
                        {
                            red = green = blue = 0; // Black
                            alpha = 255;
                        }
                        else
                        {
                            red = 255; // Pink
                            green = 0;
                            blue = 255;
                            alpha = 255;
                        }

                        pixels[index++] = blue;
                        pixels[index++] = green;
                        pixels[index++] = red;
                        pixels[index++] = alpha;
                    }
                }

                // Copy the data to the bitmap
                System.Runtime.InteropServices.Marshal.Copy(pixels, 0, bitmapData.Scan0, pixels.Length);
                bitmap.UnlockBits(bitmapData);

                return bitmap;
            });
        }

        public Task<Bitmap> GetRawImage(string item, int maxWidth, int maxHeight)
        {
            return GetProcessedImage(item, maxWidth, maxHeight);
        }

        public void Dispose()
        {
            // Dispose any resources if needed
        }
    }
}
