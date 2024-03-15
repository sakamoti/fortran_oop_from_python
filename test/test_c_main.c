/*
  test for m_shape_c.f90 from c main routine
*/
#include <stdio.h>
#include "c_f_interface.h"

int main()
{
    double area;
    void *circle = create_circle_ptr(3.0);
    if(circle == NULL) {
        fprintf(stderr, "Failed to create fortran object Circle_t from C\n");
        return 1;
    }
    area = calculatearea_circle(&circle);
    printf("calculatearea(circle) from C : %f\n",area);
    showinfo_circle(&circle);
    delete_circle_ptr(&circle);

    void *rectangle = create_rect_ptr(2.0,3.0);
    if(rectangle == NULL) {
        fprintf(stderr, "Failed to create fortran object Rectangle_t from C\n");
        return 1;
    }
    area = calculatearea_rectangle(&rectangle);
    printf("calculatearea(rectangle) from C : %f\n",area);
    showinfo_rectangle(&rectangle);
    delete_rectangle_ptr(&rectangle);
}