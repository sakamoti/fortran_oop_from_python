# fortran_oop_from_python
Sample of using fortran classes from python C extension.

- This repository contains sample code to use classes defined in Fortran from Python.
- For the binding between Python and Fortran, I use the C extension of Python.
- Pointers pointing to Fortran classes are included in PyObject as C `void*`. In this case, `PyCapsule_New` is used.
- Interoperation is made possible by converting the `void*` to a Fortran pointer on the fortran side by using `c_f_pointer`.


# Code overview

## `fortran_oop_lib/m_shape.f90`
As an example, we have an interface `type,abstruct,public :: IShape` that represents the shape, and in the method we have created a function to calculate the area of the shape. We have defined "circle" and "square" as the actual instances.

It also makes use of `pure elemental` features, so it will be easier to write constructors, etc. when the main code is fortran.

There are also methods to show the data of each class to the console.

## `pyflib/m_shape_c.f90`
This is the C interface of `m_shape.f90` defined with `iso_c_binding`.

## `pyflib/custom.c`
Python C extension code.

## `include/c_f_interface.h`
The functions defined in `m_chape_c.f90` in C header format.

## `test/fort_main.f90`
Main program which use `fortran_oop_lib/m_shape.f90` for test.

## `test/test_c_main.c`
Main program which use `fortran_oop_lib/m_shape.f90` and its binding `/pyflib/m_shape_c.f90`.

## `main.py`
python test script which load `custom.so` and use it. `custom.so` use fortran `Circle_t` type defined in the `fortran_oop_lib/m_shape.f90`.

## `Makefile`
make file which build `custom.so`, `f_main` and `c_main`.


# How to build and test run
First, build binary file. Then, run tests as follows.
```bash
make
./f_main
./c_main
python3 main.py
```

# Output samples

## `./f_main`
```bash
#--- scalar version ---
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    3.0000000000000000     
    area   :    28.274333882308138     
 【 Hello from Fortran showinfo method 】
    type   : Rectangle_t
    width  :    2.0000000000000000     
    height :    3.0000000000000000     
    area   :    6.0000000000000000     
#--- array version ---
  -- array(1) ---
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    1.0000000000000000     
    area   :    3.1415926535897931     
 【 Hello from Fortran showinfo method 】
    type   : Rectangle_t
    width  :    1.0000000000000000     
    height :    4.0000000000000000     
    area   :    4.0000000000000000     
  -- array(2) ---
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    2.0000000000000000     
    area   :    12.566370614359172     
 【 Hello from Fortran showinfo method 】
    type   : Rectangle_t
    width  :    2.0000000000000000     
    height :    5.0000000000000000     
    area   :    10.000000000000000     
  -- array(3) ---
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    3.0000000000000000     
    area   :    28.274333882308138     
 【 Hello from Fortran showinfo method 】
    type   : Rectangle_t
    width  :    3.0000000000000000     
    height :    6.0000000000000000     
    area   :    18.000000000000000
```

## `./c_main`
```bash
calculatearea(circle) from C : 28.274334
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    3.0000000000000000     
    area   :    28.274333882308138     
calculatearea(rectangle) from C : 6.000000
 【 Hello from Fortran showinfo method 】
    type   : Rectangle_t
    width  :    2.0000000000000000     
    height :    3.0000000000000000     
    area   :    6.0000000000000000
```

## `python3 main.py`
```bash
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    1.0000000000000000     
    area   :    3.1415926535897931     
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    2.0000000000000000     
    area   :    12.566370614359172     
 【 Hello from Fortran showinfo method 】
    type   : Circle_t
    radius :    3.0000000000000000     
    area   :    28.274333882308138     

# ---- get area as PyObject ---
<class 'float'> 3.141592653589793
<class 'float'> 12.566370614359172
<class 'float'> 28.274333882308138
```
