
/* Declarations of Fortran functions */
extern void *create_circle_ptr(double radius);
extern double calculatearea_circle(void **p);
extern void showinfo_circle(void **p);
extern void delete_circle_ptr(void **p);

extern void *create_rect_ptr(double width, double height);
extern double calculatearea_rectangle(void **p);
extern void showinfo_rectangle(void **p);
extern void delete_rectangle_ptr(void **p);