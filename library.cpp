// MIT License

// Copyright (c) 2023 Northn

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <d3d9.h>
#include <lunasvg.h>

#ifndef DX_SAFE_RELEASE
#define DX_SAFE_RELEASE(p) if ((p) != nullptr) { (p)->Release(); (p) = nullptr; }
#endif

extern "C" {
__declspec(dllexport) LPDIRECT3DTEXTURE9 mimgui_svg_load_from_data(const char *data, const int size, const int width, const int height) {
  auto document = lunasvg::Document::loadFromData(data, size);
  if (document == nullptr)
    return nullptr;
  auto bitmap = document->renderToBitmap(width, height);
  LPDIRECT3DTEXTURE9 texture = nullptr;
  auto device = *reinterpret_cast<IDirect3DDevice9 **>(0xC97C28);
  if (device->CreateTexture(width, height, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, &texture, nullptr) != D3D_OK)
    return nullptr;
  D3DLOCKED_RECT locked_rect;
  if (texture->LockRect(0, &locked_rect, nullptr, 0) != D3D_OK) {
    DX_SAFE_RELEASE(texture);
    return nullptr;
  }
  memcpy(locked_rect.pBits, bitmap.data(), bitmap.width() * bitmap.height() * 4);
  texture->UnlockRect(0);
  return texture;
}

__declspec(dllexport) void mimgui_svg_release(LPDIRECT3DTEXTURE9 tex) {
  DX_SAFE_RELEASE(tex);
}

__declspec(dllexport) const char *mimgui_svg_version() {
  return MIMGUI_SVG_VERSION;
}
}
