#!/bin/python3

class TInt: name = "TInt"
class TLong: name = "TLong"
class TDouble: name = "TDouble"
class TUInt: name = "TUInt"
class TULong: name = "TULong"
class TIdentifier: name = "TIdentifier"
class Bool: name = "Bool"
class List: name = "List"

""" AST """ ############################################################################################################

ast = [

    # /include/ast/ast.hpp
    ["CConst", [], []],
    ["CConstInt", [(TInt, "value")], []],
    ["CConstLong", [(TLong, "value")], []],
    ["CConstDouble", [(TDouble, "value")], []],
    ["CConstUInt", [(TUInt, "value")], []],
    ["CConstULong", [(TULong, "value")], []],

    # /include/ast/front_symt.hpp
    ["Type", [], []],
    ["Int", [], []],
    ["Long", [], []],
    ["Double", [], []],
    ["UInt", [], []],
    ["ULong", [], []],
    ["FunType", [], ["[param_types", "ret_type"]],
    ["Pointer", [], ["ref_type"]],
    ["Array", [], ["size", "elem_type"]],
    ["StaticInit", [], []],
    ["IntInit", [(TInt, "value")], []],
    ["LongInit", [(TLong, "value")], []],
    ["DoubleInit", [(TDouble, "value"), (TULong, "binary")], []],
    ["UIntInit", [(TUInt, "value")], []],
    ["ULongInit", [(TULong, "value")], []],
    ["ZeroInit", [(TInt, "bytes")], []],
    ["InitialValue", [], []],
    ["Tentative", [], []],
    ["Initial", [], ["[static_init_list"]],
    ["NoInitializer", [], []],
    ["IdentifierAttr", [], []],
    ["FunAttr", [(Bool, "is_defined"), (Bool, "is_global")], []],
    ["StaticAttr", [(Bool, "is_global")], ["init"]],
    ["LocalAttr", [], []],
    ["Symbol", [], ["type_t", "attrs"]],

    # /include/ast/back_symt.hpp
    ["AssemblyType", [], []],
    ["LongWord", [], []],
    ["QuadWord", [], []],
    ["BackendDouble", [], []],
    ["BackendSymbol", [], []],
    ["BackendObj", [(Bool, "is_static"), (Bool, "is_constant")], ["assembly_type"]],
    ["BackendFun", [(Bool, "is_defined")], []],

    # /include/ast/front_ast.hpp
    ["CUnaryOp", [], []],
    ["CComplement", [], []],
    ["CNegate", [], []],
    ["CNot", [], []],
    ["CBinaryOp", [], []],
    ["CAdd", [], []],
    ["CSubtract", [], []],
    ["CMultiply", [], []],
    ["CDivide", [], []],
    ["CRemainder", [], []],
    ["CBitAnd", [], []],
    ["CBitOr", [], []],
    ["CBitXor", [], []],
    ["CBitShiftLeft", [], []],
    ["CBitShiftRight", [], []],
    ["CAnd", [], []],
    ["COr", [], []],
    ["CEqual", [], []],
    ["CNotEqual", [], []],
    ["CLessThan", [], []],
    ["CLessOrEqual", [], []],
    ["CGreaterThan", [], []],
    ["CGreaterOrEqual", [], []],
    ["CAbstractDeclarator", [], []],
    ["CAbstractPointer", [], ["abstract_declarator"]],
    ["CAbstractArray", [], ["size", "abstract_declarator"]],
    ["CAbstractBase", [], []],
    ["CParam", [], ["declarator", "param_type"]],
    ["CDeclarator", [], []],
    ["CIdent", [(TIdentifier, "name")], []],
    ["CPointerDeclarator", [], ["declarator"]],
    ["CArrayDeclarator", [], ["size", "declarator"]],
    ["CFunDeclarator", [], ["[param_list", "declarator"]],
    ["CExp", [], ["exp_type"]],
    ["CConstant", [], ["constant", "exp_type"]],
    ["CVar", [(TIdentifier, "name")], ["exp_type"]],
    ["CCast", [], ["exp", "target_type", "exp_type"]],
    ["CUnary", [], ["unary_op", "exp", "exp_type"]],
    ["CBinary", [], ["binary_op", "exp_left", "exp_right", "exp_type"]],
    ["CAssignment", [], ["exp_left", "exp_right", "exp_type"]],
    ["CConditional", [], ["condition", "exp_middle", "exp_right", "exp_type"]],
    ["CFunctionCall", [(TIdentifier, "name")], ["[args", "exp_type"]],
    ["CDereference", [], ["exp", "exp_type"]],
    ["CAddrOf", [], ["exp", "exp_type"]],
    ["CSubscript", [], ["exp_1", "exp_2", "exp_type"]],
    ["CStatement", [], []],
    ["CReturn", [], ["exp"]],
    ["CExpression", [], ["exp"]],
    ["CIf", [], ["condition", "then", "else_fi"]],
    ["CGoto", [(TIdentifier, "target")], []],
    ["CLabel", [(TIdentifier, "target")], ["jump_to"]],
    ["CCompound", [], ["block"]],
    ["CWhile", [(TIdentifier, "target")], ["condition", "body"]],
    ["CDoWhile", [(TIdentifier, "target")], ["condition", "body"]],
    ["CFor", [(TIdentifier, "target")], ["init", "condition", "post", "body"]],
    ["CBreak", [(TIdentifier, "target")], []],
    ["CContinue", [(TIdentifier, "target")], []],
    ["CNull", [], []],
    ["CForInit", [], []],
    ["CInitDecl", [], ["init"]],
    ["CInitExp", [], ["init"]],
    ["CBlock", [], []],
    ["CB", [], ["[block_items"]],
    ["CBlockItem", [], []],
    ["CS", [], ["statement"]],
    ["CD", [], ["declaration"]],
    ["CStorageClass", [], []],
    ["CStatic", [], []],
    ["CExtern", [], []],
    ["CInitializer", [], ["init_type"]],
    ["CSingleInit", [], ["exp", "init_type"]],
    ["CCompoundInit", [], ["[initializers", "init_type"]],
    ["CFunctionDeclaration", [(TIdentifier, "name"), (TIdentifier, "[params")], ["body", "fun_type", "storage_class"]],
    ["CVariableDeclaration", [(TIdentifier, "name")], ["init", "var_type", "storage_class"]],
    ["CDeclaration", [], []],
    ["CFunDecl", [], ["function_decl"]],
    ["CVarDecl", [], ["variable_decl"]],
    ["CProgram", [], ["[declarations"]],

    # /include/ast/interm_ast.hpp
    ["TacUnaryOp", [], []],
    ["TacComplement", [], []],
    ["TacNegate", [], []],
    ["TacNot", [], []],
    ["TacBinaryOp", [], []],
    ["TacAdd", [], []],
    ["TacSubtract", [], []],
    ["TacMultiply", [], []],
    ["TacDivide", [], []],
    ["TacRemainder", [], []],
    ["TacBitAnd", [], []],
    ["TacBitOr", [], []],
    ["TacBitXor", [], []],
    ["TacBitShiftLeft", [], []],
    ["TacBitShiftRight", [], []],
    ["TacEqual", [], []],
    ["TacNotEqual", [], []],
    ["TacLessThan", [], []],
    ["TacLessOrEqual", [], []],
    ["TacGreaterThan", [], []],
    ["TacGreaterOrEqual", [], []],
    ["TacValue", [], []],
    ["TacConstant", [], ["constant"]],
    ["TacVariable", [(TIdentifier, "name")], []],
    ["TacExpResult", [], []],
    ["TacPlainOperand", [], ["val"]],
    ["TacDereferencedPointer", [], ["val"]],
    ["TacInstruction", [], []],
    ["TacReturn", [], ["val"]],
    ["TacSignExtend", [], ["src", "dst"]],
    ["TacTruncate", [], ["src", "dst"]],
    ["TacZeroExtend", [], ["src", "dst"]],
    ["TacDoubleToInt", [], ["src", "dst"]],
    ["TacDoubleToUInt", [], ["src", "dst"]],
    ["TacIntToDouble", [], ["src", "dst"]],
    ["TacUIntToDouble", [], ["src", "dst"]],
    ["TacFunCall", [(TIdentifier, "name")], ["[args", "dst"]],
    ["TacUnary", [], ["unary_op", "src", "dst"]],
    ["TacBinary", [], ["binary_op", "src1", "src2", "dst"]],
    ["TacCopy", [], ["src", "dst"]],
    ["TacGetAddress", [], ["src", "dst"]],
    ["TacLoad", [], ["src_ptr", "dst"]],
    ["TacStore", [], ["src", "dst_ptr"]],
    ["TacJump", [(TIdentifier, "target")], []],
    ["TacJumpIfZero", [(TIdentifier, "target")], ["condition"]],
    ["TacJumpIfNotZero", [(TIdentifier, "target")], ["condition"]],
    ["TacLabel", [(TIdentifier, "name")], []],
    ["TacTopLevel", [], []],
    ["TacFunction", [(TIdentifier, "name"), (Bool, "is_global"), (TIdentifier, "[params")], ["[body"]],
    ["TacStaticVariable", [(TIdentifier, "name"), (Bool, "is_global")], ["static_init_type", "initial_value"]],
    ["TacProgram", [], ["[static_variable_top_levels", "[function_top_levels"]],

    # /include/ast/back_ast.hpp
    ["AsmReg", [], []],
    ["AsmAx", [], []],
    ["AsmCx", [], []],
    ["AsmDx", [], []],
    ["AsmDi", [], []],
    ["AsmSi", [], []],
    ["AsmR8", [], []],
    ["AsmR9", [], []],
    ["AsmR10", [], []],
    ["AsmR11", [], []],
    ["AsmSp", [], []],
    ["AsmBp", [], []],
    ["AsmXMM0", [], []],
    ["AsmXMM1", [], []],
    ["AsmXMM2", [], []],
    ["AsmXMM3", [], []],
    ["AsmXMM4", [], []],
    ["AsmXMM5", [], []],
    ["AsmXMM6", [], []],
    ["AsmXMM7", [], []],
    ["AsmXMM14", [], []],
    ["AsmXMM15", [], []],
    ["AsmCondCode", [], []],
    ["AsmE", [], []],
    ["AsmNE", [], []],
    ["AsmG", [], []],
    ["AsmGE", [], []],
    ["AsmL", [], []],
    ["AsmLE", [], []],
    ["AsmA", [], []],
    ["AsmAE", [], []],
    ["AsmB", [], []],
    ["AsmBE", [], []],
    ["AsmP", [], []],
    ["AsmOperand", [], []],
    ["AsmImm", [(Bool, "is_quad"), (TIdentifier, "value")], []],
    ["AsmRegister", [], ["reg"]],
    ["AsmPseudo", [(TIdentifier, "name")], []],
    ["AsmMemory", [(TInt, "value")], ["reg"]],
    ["AsmData", [(TIdentifier, "name")], []],
    ["AsmBinaryOp", [], []],
    ["AsmAdd", [], []],
    ["AsmSub", [], []],
    ["AsmMult", [], []],
    ["AsmDivDouble", [], []],
    ["AsmBitAnd", [], []],
    ["AsmBitOr", [], []],
    ["AsmBitXor", [], []],
    ["AsmBitShiftLeft", [], []],
    ["AsmBitShiftRight", [], []],
    ["AsmUnaryOp", [], []],
    ["AsmNot", [], []],
    ["AsmNeg", [], []],
    ["AsmShr", [], []],
    ["AsmInstruction", [], []],
    ["AsmMov", [], ["assembly_type", "src", "dst"]],
    ["AsmMovSx", [], ["src", "dst"]],
    ["AsmMovZeroExtend", [], ["src", "dst"]],
    ["AsmLea", [], ["src", "dst"]],
    ["AsmCvttsd2si", [], ["assembly_type", "src", "dst"]],
    ["AsmCvtsi2sd", [], ["assembly_type", "src", "dst"]],
    ["AsmUnary", [], ["unary_op", "assembly_type", "dst"]],
    ["AsmBinary", [], ["binary_op", "assembly_type", "src", "dst"]],
    ["AsmCmp", [], ["assembly_type", "src", "dst"]],
    ["AsmIdiv", [], ["assembly_type", "src"]],
    ["AsmDiv", [], ["assembly_type", "src"]],
    ["AsmCdq", [], ["assembly_type"]],
    ["AsmJmp", [(TIdentifier, "target")], []],
    ["AsmJmpCC", [(TIdentifier, "target")], ["cond_code"]],
    ["AsmSetCC", [], ["cond_code", "dst"]],
    ["AsmLabel", [(TIdentifier, "name")], []],
    ["AsmPush", [], ["src"]],
    ["AsmCall", [(TIdentifier, "name")], []],
    ["AsmRet", [], []],
    ["AsmTopLevel", [], []],
    ["AsmFunction", [(TIdentifier, "name"), (Bool, "is_global")], ["[instructions"]],
    ["AsmStaticVariable", [(TIdentifier, "name"), (TInt, "alignment"), (Bool, "is_global")], ["initial_value"]],
    ["AsmStaticConstant", [(TIdentifier, "name"), (TInt, "alignment")], ["initial_value"]],
    ["AsmProgram", [], ["[static_constant_top_levels", "[top_levels"]],
]

