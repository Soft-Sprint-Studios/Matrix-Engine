#ifndef SHDRCHK_H
#define SHDRCHK_H

#include <string>
#include <windows.h>

namespace obf {
	bool RunIntegrityCheck(const std::string& filePath);
}

#endif // SHDRCHK_H
