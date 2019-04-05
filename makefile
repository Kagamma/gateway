BUILD_PATH = build
RELEASE_PATH = release

MAIN = src/gateway.lpr
TEST = src/gatewayTests.lpr
UNITS = -Fumodules/brookframework/* -Fusrc/*
TEST_UNITS = -Fumodules/fptest/* -Fumodules/fptest/3rdparty/* -Fumodules/fptest/src/*
INCLUDES = -Fimodules/brookframework/*
LIBS = -Flmodules/mormot/static/i386-win32
BUILD_OUTPUT = -FE${BUILD_PATH} -FU${BUILD_PATH}
RELEASE_OUTPUT = -FE${RELEASE_PATH} -FU${BUILD_PATH}

init:
	git submodule update --init --recursive
	git --git-dir=modules/brookframework/.git --work-tree=modules/brookframework checkout 5c80b9bb122850a2fbbfe1ed3bc0d47e09c50e06

build:
	mkdir build || true
	fpc ${MAIN} ${UNITS} ${INCLUDES} ${LIBS} ${BUILD_OUTPUT} ${ARGS} -Mdelphi -g

test:
	if not exist ${BUILD_PATH} ( mkdir ${BUILD_PATH} )
	fpc ${TEST} ${UNITS} ${TEST_UNITS} ${INCLUDES} ${LIBS} ${BUILD_OUTPUT} ${ARGS} -Mdelphi -g
	${BUILD_PATH}\gatewayTests

run:
	./${BUILD_PATH}/gateway
