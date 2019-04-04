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

install:
	git submodule update --init --recursive
	git --git-dir=modules/brookframework/.git --work-tree=modules/brookframework checkout 5c80b9bb122850a2fbbfe1ed3bc0d47e09c50e06

clean:
	if exist ${BUILD_PATH} ( rmdir /s /q ${BUILD_PATH} )
	if exist ${RELEASE_PATH} ( rmdir /s /q ${RELEASE_PATH} )

build:
	if not exist ${BUILD_PATH} ( mkdir ${BUILD_PATH} )
	fpc ${MAIN} ${UNITS} ${INCLUDES} ${LIBS} ${BUILD_OUTPUT} ${ARGS} -Mdelphi -g

release:
	if not exist ${BUILD_PATH} ( mkdir ${BUILD_PATH} )
	if not exist ${RELEASE_PATH} ( mkdir ${RELEASE_PATH} )
	fpc ${MAIN} ${UNITS} ${INCLUDES} ${LIBS} ${RELEASE_OUTPUT} ${ARGS} -Mdelphi -O2 -Xg -Xs

test:
	if not exist ${BUILD_PATH} ( mkdir ${BUILD_PATH} )
	fpc ${TEST} ${UNITS} ${TEST_UNITS} ${INCLUDES} ${LIBS} ${BUILD_OUTPUT} ${ARGS} -Mdelphi -g
	${BUILD_PATH}\gatewayTests

run:
	${BUILD_PATH}\gateway
