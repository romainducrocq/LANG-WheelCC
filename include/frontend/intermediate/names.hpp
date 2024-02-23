#ifndef _FRONTEND_INTERMEDIATE_NAMES_HPP
#define _FRONTEND_INTERMEDIATE_NAMES_HPP

#include "ast/ast.hpp"
#include "ast/front_ast.hpp"

TIdentifier resolve_label_identifier(const TIdentifier& label);
TIdentifier resolve_variable_identifier(const TIdentifier& variable);
TIdentifier represent_label_identifier(const TIdentifier& label);
TIdentifier represent_variable_identifier(CExp* node);

#endif