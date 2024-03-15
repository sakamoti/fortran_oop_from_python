CC = gcc
FC = gfortran
CFLAGS = -O3 -fPIC
FCFLAGS = -O3 -fPIC
SHARED_FLAGS = -shared
PY_INCLUDE=`pkg-config --cflags python3-embed`
PY_LIBS=`pkg-config --libs python3-embed`
INCLUDE=-I./include
OBJDIR = ./bin
.PHONY: clean

all: custom c_main f_main

custom: custom.o m_shape.o m_shape_c.o 
	${FC} ${FCFLAGS} ${SHARED_FLAGS} ${PY_INCLUDE} -o $@.so $^ ${PY_LIBS}

custom.o: pyflib/custom.c
	${CC} ${CFLAGS} ${INCLUDE} ${PY_INCLUDE} -c $^

m_shape.o: fortran_oop_lib/m_shape.f90
	${FC} ${FCFLAGS} -c $^

m_shape_c.o: pyflib/m_shape_c.f90
	${FC} ${FCFLAGS} -c $^

c_main: test/test_c_main.c m_shape_c.o m_shape.o
	${FC} ${INCLUDE} ${CFLAGS} ${PY_INCLUDE} -o $@ $^

f_main: test/test_fort_main.f90 m_shape_c.o m_shape.o
	${FC} ${CFLAGS} ${PY_INCLUDE} -o $@ $^

clean:
	${RM} *.so *.o *.mod c_main f_main
