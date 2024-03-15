#ifndef _AST_BACK_SYMT_HPP
#define _AST_BACK_SYMT_HPP

#include "ast/ast.hpp"

#include <memory>
#include <unordered_map>

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// assembly_type = Byte
//               | LongWord
//               | QuadWord
//               | BackendDouble
//               | ByteArray(int, int)
struct AssemblyType : Ast {
    AST_T type() override;
};

struct Byte : AssemblyType {
    AST_T type() override;
};

struct LongWord : AssemblyType {
    AST_T type() override;
};

struct QuadWord : AssemblyType {
    AST_T type() override;
};

struct BackendDouble : AssemblyType {
    AST_T type() override;
};

struct ByteArray : AssemblyType {
    AST_T type() override;
    ByteArray() = default;
    ByteArray(TLong size, TInt alignment);

    TLong size;
    TInt alignment;
};

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// symbol = Obj(assembly_type, bool, bool)
//        | Fun(bool)
struct BackendSymbol : Ast {
    AST_T type() override;
};

struct BackendObj: BackendSymbol {
    AST_T type() override;
    BackendObj() = default;
    BackendObj(bool is_static, bool is_constant, std::shared_ptr<AssemblyType> assembly_type);

    bool is_static;
    bool is_constant;
    std::shared_ptr<AssemblyType> assembly_type;
};

struct BackendFun: BackendSymbol {
    AST_T type() override;
    BackendFun() = default;
    BackendFun(bool is_defined);

    bool is_defined;
};

/*
struct Dummy : Ast {
};
*/

extern std::unordered_map<TIdentifier, std::unique_ptr<BackendSymbol>> backend_symbol_table;

#endif
