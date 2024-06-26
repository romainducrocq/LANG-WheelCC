#!/bin/bash

PACKAGE_NAME="$(cat ../bin/package_name.txt)"

LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
NC='\033[0m'

TEST_DIR="${PWD}/tests"
TEST_SRCS=()
for i in $(seq 1 18); do
    TEST_SRCS+=("$(basename $(find ${TEST_DIR} -maxdepth 1 -name "${i}_*" -type d))")
done

function file () {
    FILE=${1%.*}
    if [ -f "${FILE}" ]; then rm ${FILE}; fi
    echo "${FILE}"
}

function total () {
    echo "----------------------------------------------------------------------"
    RES="${PASS} / ${TOTAL}"
    if [ ${PASS} -eq ${TOTAL} ]; then
        RES="${LIGHT_GREEN}PASS: ${RES}${NC}"
    else
        RES="${LIGHT_RED}FAIL: ${RES}${NC}"
    fi
    echo -e "${RES}"
}

function indent () {
    echo -n "$(echo "${TOTAL} [ ] ${FILE}.c" | sed -r 's/./ /g')"
}

function print_check () {
    echo " - check ${1} -> ${2}"
}

function print_fail () {
    echo -e -n "${TOTAL} ${RES} ${FILE}.c${NC}"
    PRINT="${PACKAGE_NAME}: ${RET_THIS}"
    print_check "fail" "[${PRINT}]"
}

function print_single () {
    echo -e -n "${TOTAL} ${RES} ${FILE}.c${NC}"
    if [ ${RET_PASS} -ne 0 ]; then
        PRINT="${COMP_2}: ${RET_THIS}"
        print_check "return" "[${PRINT}]"
    else
        PRINT="${COMP_1}: ${RET_GCC}, ${COMP_2}: ${RET_THIS}"
        print_check "return" "[${PRINT}]"
        if [ ! -z "${OUT_THIS}" ]; then
            indent
            PRINT="${COMP_1}: \"${OUT_GCC}\", ${COMP_2}: \"${OUT_THIS}\""
            print_check "stdout" "[${PRINT}]"
        fi
    fi
}

function print_client () {
    echo -e -n "${TOTAL} ${RES} ${FILE}.c${NC}"
    if [ ${RET_PASS} -ne 0 ]; then
        PRINT="${COMP_4}: ${RET_THIS}"
        print_check "return" "[${PRINT}]"
    else
        PRINT="${COMP_1}: ${RET_GCC}, ${COMP_2}: ${RET_GCC_THIS}, "
        PRINT="${PRINT}${COMP_3}: ${RET_THIS_GCC}, ${COMP_4}: ${RET_THIS}"
        print_check "return" "[${PRINT}]"
        if [ ! -z "${OUT_THIS}" ]; then
            indent
            PRINT="${COMP_1}: \"${OUT_GCC}\", ${COMP_2}: \"${OUT_GCC_THIS}\", "
            PRINT="${PRINT}${COMP_3}: \"${OUT_THIS_GCC}\", ${COMP_4}: \"${OUT_THIS}\""
            print_check "stdout" "[${PRINT}]"
        fi
    fi
}

function check_fail () {
    ${PACKAGE_NAME}${LIBS} ${FILE}.c > /dev/null 2>&1
    RET_THIS=${?}

    if [ ${RET_THIS} -ne 0 ]; then
        RES="${LIGHT_GREEN}[y]"
        if [ ${1} -eq 0 ]; then
            let PASS+=1
        fi
    else
        RES="${LIGHT_RED}[n]"
    fi

    print_fail
}

function check_pass () {
    if [ ${RET_THIS} -ne 0 ]; then
        RES="${LIGHT_RED}[n]"
        return 1
    fi

    OUT_THIS=$(${FILE})
    RET_THIS=${?}
    rm ${FILE}

    if [ ${RET_GCC} -eq ${RET_THIS} ]; then
        if [[ "${OUT_GCC}" == "${OUT_THIS}" ]]; then
            RES="${LIGHT_GREEN}[y]"
            if [ ${1} -eq 0 ]; then
                let PASS+=1
            fi
        fi
    else
        RES="${LIGHT_RED}[n]"
    fi

    return 0
}

function check_single () {
    gcc -pedantic-errors ${FILE}.c${LIBS} -o ${FILE} > /dev/null 2>&1
    RET_GCC=${?}

    if [ ${RET_GCC} -ne 0 ]; then
        check_fail 0
        return
    fi

    OUT_GCC=$(${FILE})
    RET_GCC=${?}
    rm ${FILE}

    ${PACKAGE_NAME}${LIBS} ${FILE}.c > /dev/null 2>&1
    RET_THIS=${?}

    check_pass 0
    RET_PASS=${?}

    COMP_1="gcc"
    COMP_2="${PACKAGE_NAME}"
    print_single
}

function check_data () {
    gcc -pedantic-errors -c ${FILE}_data.s${LIBS} -o ${FILE}_data.o > /dev/null 2>&1
    gcc -pedantic-errors -c ${FILE}.c${LIBS} -o ${FILE}.o > /dev/null 2>&1
    gcc -pedantic-errors ${FILE}.o ${FILE}_data.o${LIBS} -o ${FILE} > /dev/null 2>&1
    OUT_GCC=$(${FILE})
    RET_GCC=${?}
    rm ${FILE}

    if [ -f "${FILE}.o" ]; then rm ${FILE}.o; fi

    ${PACKAGE_NAME} -c${LIBS} ${FILE}.c > /dev/null 2>&1
    RET_THIS=${?}

    if [ ${RET_THIS} -eq 0 ]; then
        gcc -pedantic-errors ${FILE}.o ${FILE}_data.s${LIBS} -o ${FILE} > /dev/null 2>&1
        RET_THIS=${?}
    fi

    if [ -f "${FILE}.o" ]; then rm ${FILE}.o; fi
    if [ -f "${FILE}_data.o" ]; then rm ${FILE}_data.o; fi

    check_pass 0
    RET_PASS=${?}

    COMP_1="gcc"
    COMP_2="${PACKAGE_NAME}"
    print_single
}

function compile_client () {
    ${PACKAGE_NAME} -c${LIBS} ${1} > /dev/null 2>&1
    RET_THIS=${?}

    if [ ${RET_THIS} -eq 0 ]; then
        gcc -pedantic-errors ${FILE}.o ${FILE}_client.o${LIBS} -o ${FILE} > /dev/null 2>&1
        RET_THIS=${?}
    fi

    if [ -f "${FILE}.o" ]; then rm ${FILE}.o; fi
    if [ -f "${FILE}_client.o" ]; then rm ${FILE}_client.o; fi
}

function check_client () {
    gcc -pedantic-errors ${FILE}.c ${FILE}_client.c${LIBS} -o ${FILE} > /dev/null 2>&1
    OUT_GCC=$(${FILE})
    RET_GCC=${?}
    rm ${FILE}

    if [ -f "${FILE}.o" ]; then rm ${FILE}.o; fi
    if [ -f "${FILE}_client.o" ]; then rm ${FILE}_client.o; fi

    gcc -pedantic-errors -c ${FILE}_client.c${LIBS} -o ${FILE}_client.o > /dev/null 2>&1
    compile_client ${FILE}.c
    check_pass 1
    RET_PASS=${?}
    RET_GCC_THIS=${RET_THIS}
    OUT_GCC_THIS=${OUT_THIS}
    if [ ${RET_PASS} -ne 0 ]; then
        COMP_4="gcc+${PACKAGE_NAME}"
        print_client
        return
    fi

    gcc -pedantic-errors -c ${FILE}.c${LIBS} -o ${FILE}.o > /dev/null 2>&1
    compile_client ${FILE}_client.c
    check_pass 1
    RET_PASS=${?}
    RET_THIS_GCC=${RET_THIS}
    OUT_THIS_GCC=${OUT_THIS}
    if [ ${RET_PASS} -ne 0 ]; then
        COMP_4="${PACKAGE_NAME}+gcc"
        print_client
        return
    fi

    ${PACKAGE_NAME} -c${LIBS} ${FILE}.c > /dev/null 2>&1
    compile_client ${FILE}_client.c
    check_pass 0
    RET_PASS=${?}

    COMP_1="gcc"
    COMP_2="gcc+${PACKAGE_NAME}"
    COMP_3="${PACKAGE_NAME}+gcc"
    COMP_4="${PACKAGE_NAME}"
    print_client
}

function check_test () {
    FILE=$(file ${1})
    if [[ "${FILE}" == *"_client" ]]; then
        return
    fi

    let TOTAL+=1

    LIBS=""
    if [[ "${FILE}" == *"__+l"* ]]; then
        LIBS=" -"$(echo "${FILE}" | cut -d "+" -f2- | tr "+" "-" | tr "_" " ")
    fi

    if [ -f "${FILE}_data.s" ]; then
        check_data
        return
    fi

    if [ -f "${FILE}_client.c" ]; then
        check_client
        return
    fi

    # gcc outputs only a warning here
    if [[ "${FILE}" == "${TEST_SRCS[16]}/invalid_types/void/void_fun_params" ]]; then
        check_fail 0
        return
    fi

    check_single
}

function test_src () {
    SRC=${1}
    for FILE in $(find ${SRC} -name "*.c" -type f | sort --uniq)
    do
        check_test ${FILE}
    done
}

function test_all () {
    for SRC in ${TEST_SRCS[@]}
    do
        test_src ${SRC}
    done
}

LIBS=""
PASS=0
TOTAL=0
cd ${TEST_DIR}
if [ ! -z "${1}" ]; then
    test_src ${TEST_SRCS["$((${1} - 1))"]}
else
    test_all
fi
total

exit 0
