PROJECT_NAME = cskel
SOURCES = main.c module.c

CC=c99
INCLUDES=``
LIBS=``
CFLAGS=-O3 -ggdb -Wpedantic ${INCLUDES}

ROOT_DIR:=${PWD}

BUILD_DIR:=${ROOT_DIR}/build
IDIR:=${ROOT_DIR}/include
SRC_DIR:=${ROOT_DIR}/src

ODIR:=${BUILD_DIR}/${PROJECT_NAME}-o
OBJS = $(patsubst %.c,${ODIR}/%.o,${SOURCES})
.PHONY: all clean compile_commands

BIN = ${BUILD_DIR}/${PROJECT_NAME}

all: ${BIN} compile_commands

${BIN}: ${OBJS}
	@cd ${BUILD_DIR}
	${CC} ${CFLAGS} ${LIBS} -o $@ $^

${ODIR}/%.o: ${SRC_DIR}/%.c
	@test -d ${ODIR} || mkdir -p ${ODIR}
	@cd ${ODIR}
	${CC} ${CFLAGS} ${LIBS} -I${IDIR} -c $< -o $@

compile_commands:
	@test -e compile_commands.py && python compile_commands.py ${SOURCES} \
		--compiler ${CC} \
		--sourcedir ${SRC_DIR} \
		--includedir ${IDIR} \
		--odir ${ODIR} \
		--builddir ${BUILD_DIR} \
		--cflags " ${CFLAGS}" \
		--libs " ${LIBS}" ||\
		echo "ERROR: compile_commands.py faild"

	@test -e ${BUILD_DIR}/compile_commands.json && \
		ln -sf ${BUILD_DIR}/compile_commands.json ${ROOT_DIR} || \
		echo "ERROR: compile_commands.json does not exist"

clean:
	rm -rf compile_commands.json
	rm -rf ${BUILD_DIR}

# make special vars
# $@ full target name of the current target
# $? returns the dependencies that are newer than the current target
# $* returns the text that corresponds to % in the target
# $< name of the first dependency
# $^ name of all the dependencies with space as the delimiter
