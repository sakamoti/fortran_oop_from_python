#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include "structmember.h"
#include "c_f_interface.h"

typedef struct{
    PyObject_HEAD
    PyObject *capsule_f_circle; /* fortran Circle_t */
} CustomCircle;

void f_circle_destructor(PyObject *capsule_f_circle) {
    void *f_circle = PyCapsule_GetPointer(capsule_f_circle, "custom._Circle");
    if(f_circle){
        delete_circle_ptr(&f_circle);
    }
}

static void
CustomCircle_dealloc(CustomCircle *self) {
    Py_XDECREF(self->capsule_f_circle);
    Py_TYPE(self)->tp_free((PyObject *) self);
}

static PyObject *
Custom_new(PyTypeObject *type, PyObject *args, PyObject *kwds) {
    double radius;
    if(!PyArg_ParseTuple(args, "d", &radius)){
        return NULL;
    }
    CustomCircle *self = (CustomCircle *) type->tp_alloc(type, 0);
    if(self != NULL){
        void *circle = create_circle_ptr(radius);
        if (circle == NULL) {
            Py_DECREF(self);
            return PyErr_NoMemory();
        }
        self->capsule_f_circle = PyCapsule_New(circle, "custom._Circle", f_circle_destructor);
        if (self->capsule_f_circle == NULL) {
            delete_circle_ptr(&circle);
            Py_DECREF(self);
            return NULL;
        }
        // showinfo_circle(&circle);
    }
    return (PyObject *)self;
}

static PyObject *
Custom_showinfo(CustomCircle *self, PyObject *Py_UNUSED(ignored))
{
    if (self->capsule_f_circle == NULL) { PyErr_SetString(PyExc_AttributeError, "capsule_f_circle");
        return NULL;
    }
    void *f_circle = PyCapsule_GetPointer(self->capsule_f_circle, "custom._Circle");
    showinfo_circle(&f_circle);
    Py_RETURN_NONE;
}

static PyObject *
PyCustom_calculatearea(CustomCircle *self, PyObject *Py_UNUSED(ignored))
{
    if (self->capsule_f_circle == NULL) { PyErr_SetString(PyExc_AttributeError, "capsule_f_circle");
        return NULL;
    }
    void *f_circle = PyCapsule_GetPointer(self->capsule_f_circle, "custom._Circle");
    double area = calculatearea_circle(&f_circle);
    return (PyObject*) PyFloat_FromDouble(area);
}

static PyMethodDef Custom_methods[] = {
    {"calculatearea", (PyCFunction) PyCustom_calculatearea, METH_NOARGS, "call fortran circle method" },
    {"showinfo", (PyCFunction) Custom_showinfo, METH_NOARGS, "show informations of fortran circle class" },
    {NULL}  /* Sentinel */
};

static PyTypeObject CustomType = {
    .ob_base = PyVarObject_HEAD_INIT(NULL, 0)
    .tp_name = "custom.FCircle",
    .tp_doc = PyDoc_STR("Fortran Circle_t object"),
    .tp_basicsize = sizeof(CustomCircle),
    .tp_itemsize = 0,
    .tp_flags = Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE,
    .tp_new = Custom_new,
    .tp_dealloc = (destructor) CustomCircle_dealloc,
    .tp_methods = Custom_methods,
};


static struct PyModuleDef custommodule = {
    .m_base = PyModuleDef_HEAD_INIT, 
    .m_name = "custom",
    .m_doc = "Example module that creates an extension type.", 
    .m_size = -1,
};

PyMODINIT_FUNC
PyInit_custom(void){
    PyObject *m;
    if (PyType_Ready(&CustomType) < 0) return NULL;
    
    m = PyModule_Create(&custommodule);
    if (m == NULL) return NULL;

    Py_INCREF(&CustomType);
    if (PyModule_AddObject(m, "CustomCircle", (PyObject *) &CustomType) < 0) {
        Py_DECREF(&CustomType);
        Py_DECREF(m);
        return NULL;
    }
    return m;
}
