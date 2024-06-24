#include <fstream>
#include <string>
#include "shdrchk.h"

namespace obf {

    bool RunIntegrityCheck(const std::string& filePath) {
        std::ifstream f(filePath, std::ios::binary | std::ios::ate);
        if (!f.is_open()) {
            MessageBox(NULL, "Integrity check failed.", "Error", MB_ICONERROR | MB_OK);
            exit(0);
            return false;
        }

        auto end = f.tellg();
        if (end < 4) {
            MessageBox(NULL, "Integrity check failed.", "Error", MB_ICONERROR | MB_OK);
            exit(0);
            return false;
        }

        f.seekg(end - static_cast<std::streamoff>(4), std::ios::beg);

        const char marker[4] = { 0x50, 0x41, 0x52, 0x41 };
        char buf[4];

        if (!f.read(buf, sizeof(buf)) || std::memcmp(buf, marker, sizeof(buf)) != 0) {
            MessageBox(NULL, "Integrity check failed.", "Error", MB_ICONERROR | MB_OK);
            exit(0);
            return false;
        }

        return true;
    }

} // namespace obf
