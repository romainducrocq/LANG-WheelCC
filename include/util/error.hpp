#ifndef _UTIL_ERROR_HPP
#define _UTIL_ERROR_HPP

#include <string>

void set_filename(const std::string& _filename);
const std::string em(const std::string& message);
[[ noreturn ]] void raise_runtime_error(const std::string& message);
[[ noreturn ]] void raise_runtime_error_at_line(const std::string& message, size_t line_number);
[[ noreturn ]] void raise_internal_error(const char* func, const char* file, int line);
#define RAISE_INTERNAL_ERROR raise_internal_error(__func__, __FILE__, __LINE__)

#endif
