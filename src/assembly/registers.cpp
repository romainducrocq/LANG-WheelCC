#include "assembly/registers.hpp"

#include "util/error.hpp"
#include "ast/asm_ast.hpp"

#include <memory>

/**
cdef AsmRegister generate_register(int32 register_kind):
    # reg = AX | CX | DX | DI | SI | R8 | R9 | R10 | R11 | SP | XMM0 | XMM1 | XMM2 | XMM3 | XMM4 | XMM5 | XMM6 | XMM7
    #     | XMM14 | XMM15
    cdef AsmReg reg
    if register_kind == REGISTER_KIND.get('Ax'):
        reg = AsmAx()
    elif register_kind == REGISTER_KIND.get('Cx'):
        reg = AsmCx()
    elif register_kind == REGISTER_KIND.get('Dx'):
        reg = AsmDx()
    elif register_kind == REGISTER_KIND.get('Di'):
        reg = AsmDi()
    elif register_kind == REGISTER_KIND.get('Si'):
        reg = AsmSi()
    elif register_kind == REGISTER_KIND.get('R8'):
        reg = AsmR8()
    elif register_kind == REGISTER_KIND.get('R9'):
        reg = AsmR9()
    elif register_kind == REGISTER_KIND.get('R10'):
        reg = AsmR10()
    elif register_kind == REGISTER_KIND.get('R11'):
        reg = AsmR11()
    elif register_kind == REGISTER_KIND.get('Sp'):
        reg = AsmSp()
    elif register_kind == REGISTER_KIND.get('Xmm0'):
        reg = AsmXMM0()
    elif register_kind == REGISTER_KIND.get('Xmm1'):
        reg = AsmXMM1()
    elif register_kind == REGISTER_KIND.get('Xmm2'):
        reg = AsmXMM2()
    elif register_kind == REGISTER_KIND.get('Xmm3'):
        reg = AsmXMM3()
    elif register_kind == REGISTER_KIND.get('Xmm4'):
        reg = AsmXMM4()
    elif register_kind == REGISTER_KIND.get('Xmm5'):
        reg = AsmXMM5()
    elif register_kind == REGISTER_KIND.get('Xmm6'):
        reg = AsmXMM6()
    elif register_kind == REGISTER_KIND.get('Xmm7'):
        reg = AsmXMM7()
    elif register_kind == REGISTER_KIND.get('Xmm14'):
        reg = AsmXMM14()
    elif register_kind == REGISTER_KIND.get('Xmm15'):
        reg = AsmXMM15()
    else:

        raise RuntimeError(
            f"An error occurred in register management, unmanaged register [{register_kind}]")

    return AsmRegister(reg)
*/
// reg = AX | CX | DX | DI | SI | R8 | R9 | R10 | R11 | SP | XMM0 | XMM1 | XMM2 | XMM3 | XMM4 | XMM5 | XMM6 | XMM7
//     | XMM14 | XMM15
std::shared_ptr<AsmRegister> generate_register(REGISTER_KIND register_kind) {
    std::unique_ptr<AsmReg> reg;
    switch(register_kind) {
        case REGISTER_KIND::Ax:
            reg = std::make_unique<AsmAx>();
            break;
        case REGISTER_KIND::Cx:
            reg = std::make_unique<AsmCx>();
            break;
        case REGISTER_KIND::Dx:
            reg = std::make_unique<AsmDx>();
            break;
        case REGISTER_KIND::Di:
            reg = std::make_unique<AsmDi>();
            break;
        case REGISTER_KIND::Si:
            reg = std::make_unique<AsmSi>();
            break;
        case REGISTER_KIND::R8:
            reg = std::make_unique<AsmR8>();
            break;
        case REGISTER_KIND::R9:
            reg = std::make_unique<AsmR9>();
            break;
        case REGISTER_KIND::R10:
            reg = std::make_unique<AsmR10>();
            break;
        case REGISTER_KIND::R11:
            reg = std::make_unique<AsmR11>();
            break;
        case REGISTER_KIND::Sp:
            reg = std::make_unique<AsmSp>();
            break;
        case REGISTER_KIND::Xmm0:
            reg = std::make_unique<AsmXMM0>();
            break;
        case REGISTER_KIND::Xmm1:
            reg = std::make_unique<AsmXMM1>();
            break;
        case REGISTER_KIND::Xmm2:
            reg = std::make_unique<AsmXMM2>();
            break;
        case REGISTER_KIND::Xmm3:
            reg = std::make_unique<AsmXMM3>();
            break;
        case REGISTER_KIND::Xmm4:
            reg = std::make_unique<AsmXMM4>();
            break;
        case REGISTER_KIND::Xmm5:
            reg = std::make_unique<AsmXMM5>();
            break;
        case REGISTER_KIND::Xmm6:
            reg = std::make_unique<AsmXMM6>();
            break;
        case REGISTER_KIND::Xmm7:
            reg = std::make_unique<AsmXMM7>();
            break;
        case REGISTER_KIND::Xmm14:
            reg = std::make_unique<AsmXMM14>();
            break;
        case REGISTER_KIND::Xmm15:
            reg = std::make_unique<AsmXMM15>();
            break;
        default:
            RAISE_INTERNAL_ERROR;
    }
    return std::make_shared<AsmRegister>(std::move(reg));
}