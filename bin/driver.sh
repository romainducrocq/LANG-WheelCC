#!/bin/bash

PACKAGE_DIR="$(echo $(dirname $(readlink -f ${0})))"
PACKAGE_NAME="$(cat $(echo ${PACKAGE_DIR})/package_name.txt)"

ARGC=${#}
ARGV=(${@})

function verbose () {
    if [ ${VERB_CODE} -eq 1 ]; then
        echo "${1}"
    fi
}

function usage () {
    echo "Usage: ${PACKAGE_NAME} [Help] [Debug] [Link] [Lib] FILES"
    echo ""
    echo "[Help]:"
    echo "    --help       print help and exit"
    echo ""
    echo "[Debug]:"
    echo "    -v           enable verbose mode"
    echo "    (Debug only):"
    echo "    --lex        print  lexing    stage and exit"
    echo "    --parse      print  parsing   stage and exit"
    echo "    --validate   print  semantic  stage and exit"
    echo "    --tacky      print  interm    stage and exit"
    echo "    --codegen    print  assembly  stage and exit"
    echo "    --codeemit   print  emission  stage and exit"
    echo ""
    echo "[Link]:"
    echo "    -S           compile, but do not assemble and link"
    echo "    -c           compile and assemble, but do not link"
    echo ""
    echo "[Lib]:"
    echo "    -l<libname>  links with a library file"
    echo ""
    echo "FILES:           list of .c files to compile"
    exit 0
}

function clean () {
    if [ ${EXIT_CODE} -eq 1 ]; then
        LINK_CODE=255
    fi
    for FILE in ${FILES}; do
        if [ -f ${FILE}.i ]; then rm ${FILE}.i; fi
        if [ ${LINK_CODE} -ne 0 ]; then
            if [ -f ${FILE} ]; then rm ${FILE}; fi
        fi
        if [ ${LINK_CODE} -ne 1 ]; then
            if [ -f ${FILE}.s ]; then rm ${FILE}.s; fi
            if [ -f ${FILE}.asm ]; then rm ${FILE}.asm; fi
        fi
        if [ ${LINK_CODE} -ne 2 ]; then
            if [ -f ${FILE}.o ]; then rm ${FILE}.o; fi
        fi
    done
    exit ${EXIT_CODE}
}

function shift_arg () {
    if [ ${i} -lt ${ARGC} ]; then
        ARG="${ARGV[${i}]}"
        i=$((i+1))
        return 0
    else
        ARG=""
        return 1
    fi
}

function help_arg () {
    if [ "${ARG}" = "--help" ]; then
        usage
    fi
    return 0;
}

function verb_arg () {
    if [ "${ARG}" = "-v" ]; then
        VERB_CODE=1
    else
        return 1
    fi
    return 0
}

function opt_arg () {
    if [ "${ARG}" = "-v" ]; then
        OPT_CODE=1
    elif [ "${ARG}" = "--lex" ]; then
        OPT_CODE=255
    elif [ "${ARG}" = "--parse" ]; then
        OPT_CODE=254
    elif [ "${ARG}" = "--validate" ]; then
        OPT_CODE=253
    elif [ "${ARG}" = "--tacky" ]; then
        OPT_CODE=252
    elif [ "${ARG}" = "--codegen" ]; then
        OPT_CODE=251
    elif [ "${ARG}" = "--codeemit" ]; then
        OPT_CODE=250
    elif [ ${VERB_CODE} -eq 1 ]; then
        OPT_CODE=1
        return 1;
    else
        return 1
    fi
    return 0
}

function link_arg () {
    if [ "${ARG}" = "-S" ]; then
        LINK_CODE=1
    elif [ "${ARG}" = "-c" ]; then
        LINK_CODE=2
    else
        return 1
    fi
    return 0
}

function file_arg () {
    if [[ "${ARG}" == *".${EXT_IN}" ]]; then
      FILE="$(readlink -f ${ARG})"
      if [ ${?} -ne 0 ]; then return 1; fi
      FILE="${FILE%.*}"
      if [ -z ${FILES} ]; then
          if [ -z ${NAME_OUT} ]; then
              NAME_OUT=${FILE}
          fi
      else
          FILES="${FILES} "
          FILE_2=1
      fi
      FILES="${FILES}${FILE%.*}"
      FILE=""
      return 0
    fi
    return 1
}

function lib_arg () {
    if [[ "${ARG}" == "-l"* ]]; then
      LINK_LIBS="${LINK_LIBS} ${ARG}"
      return 0
    fi
    return 1
}

function parse_args () {
    i=0

    shift_arg
    if [ ${?} -ne 0 ]; then exit 1; fi
    help_arg

    if [ ${?} -ne 0 ]; then exit 1; fi
    verb_arg

    if [ ${?} -eq 0 ]; then
        shift_arg
        if [ ${?} -ne 0 ]; then exit 1; fi
    fi
    opt_arg

    if [ ${?} -eq 0 ]; then
        shift_arg
        if [ ${?} -ne 0 ]; then exit 1; fi
    fi
    link_arg

    if [ ${?} -eq 0 ]; then
        shift_arg
        if [ ${?} -ne 0 ]; then exit 1; fi
    fi
    lib_arg

    if [ ${?} -eq 0 ]; then
        shift_arg
        if [ ${?} -ne 0 ]; then exit 1; fi
    fi
    file_arg
    if [ ${?} -ne 0 ]; then exit 1; fi

    while :; do
        shift_arg
        if [ ${?} -ne 0 ]; then return 0; fi
        file_arg
        if [ ${?} -ne 0 ]; then exit 1; fi
    done
    return 1;
}

function preprocess () {
    for FILE in ${FILES}; do
        verbose "Preprocess -> ${FILE}.i"
        gcc -E -P ${FILE}.c -o ${FILE}.i
        if [ ${?} -ne 0 ]; then return 1; fi
    done
    EXT_IN="i"
    return 0;
}

function compile () {
    for FILE in ${FILES}; do
        verbose "Compile    -> ${FILE}.${EXT_OUT}"
        ${PACKAGE_DIR}/${PACKAGE_NAME} ${OPT_CODE} ${FILE}.${EXT_IN}
        if [ ${?} -ne 0 ]; then return 1; fi
        if [ ${OPT_CODE} -eq 250 ]; then
            cat ${FILE}.${EXT_OUT}
        fi
    done
    return 0;
}

function link () {
    if [ ${OPT_CODE} -lt 200 ]; then
        if [ ${LINK_CODE} -eq 0 ]; then
            if [ ${FILE_2} -eq 1 ]; then
                FILES="$(echo "${FILES}" |\
                    sed "s/ /.${EXT_OUT} /g")"
            fi
            FILES="${FILES}.${EXT_OUT}"
            gcc ${FILES}${LINK_LIBS} -o ${NAME_OUT}
            if [ ${?} -ne 0 ]; then return 1; fi
            verbose "Link       -> ${NAME_OUT}"
        elif [ ${LINK_CODE} -eq 1 ]; then
            :
        elif [ ${LINK_CODE} -eq 2 ]; then
            for FILE in ${FILES}; do
                gcc -c ${FILE}.${EXT_OUT}${LINK_LIBS} -o ${FILE}.o
                if [ ${?} -ne 0 ]; then return 1; fi
                verbose "Assemble   -> ${FILE}.o"
            done
        else
            return 1
        fi
    fi
    return 0;
}

EXIT_CODE=1

VERB_CODE=0
OPT_CODE=0
LINK_CODE=0
FILE_2=0

EXT_IN="c"
EXT_OUT="s"

LINK_LIBS=""
FILES=""
NAME_OUT=""

parse_args
if [ ${?} -ne 0 ]; then clean; fi

# preprocess
if [ ${?} -ne 0 ]; then clean; fi

compile
if [ ${?} -ne 0 ]; then clean; fi

link
if [ ${?} -ne 0 ]; then clean; fi

EXIT_CODE=0
clean
