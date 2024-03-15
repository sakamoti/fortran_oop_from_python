module m_shape_c
    use, intrinsic :: iso_c_binding
    use m_shape, only : Circle_t, Rectangle_t, ShapeFactory
    contains

        function c_void_to_circle(cptr) result(fptr)
            type(c_ptr) :: cptr
            type(Circle_t),pointer :: fptr
            if( .not. c_associated(cptr)) then
                fptr => null()
                return
            end if
            call c_f_pointer(cptr, fptr)
        end function
        function c_void_to_rectangle(cptr) result(fptr)
            type(c_ptr) :: cptr
            type(Rectangle_t),pointer :: fptr
            if( .not. c_associated(cptr)) then
                fptr => null()
                return
            end if
            call c_f_pointer(cptr, fptr)
        end function

        function create_circle_ptr(radius) result(cnewptr) bind(c)
            real(kind=c_double), value :: radius
            type(c_ptr) :: cnewptr
            type(Circle_t), pointer :: f_ptr
            integer :: stat
            allocate(f_ptr, source=ShapeFactory(radius), stat=stat)
            if (stat /= 0)then
                error stop "Allocation failed"
                cnewptr = c_null_ptr
            end if
            cnewptr = c_loc(f_ptr)
        end function

        function create_rect_ptr(width, height) result(cnewptr) bind(c)
            real(kind=c_double), value :: width, height
            type(c_ptr) :: cnewptr
            type(Rectangle_t), pointer :: f_ptr
            integer :: stat
            allocate(f_ptr, source=ShapeFactory(width, height), stat=stat)
            if (stat /= 0)then
                error stop "Allocation failed"
                cnewptr = c_null_ptr
            end if
            cnewptr = c_loc(f_ptr)
        end function

        function calculatearea_circle(cptr) result(area) bind(c)
            type(c_ptr),intent(in) :: cptr
            type(Circle_t),pointer :: fptr
            real(c_double) :: area
            fptr => c_void_to_circle(cptr)
            area = fptr%calculatearea()
        end function
        function calculatearea_rectangle(cptr) result(area) bind(c)
            type(c_ptr),intent(in) :: cptr
            type(Rectangle_t),pointer :: fptr
            real(c_double) :: area
            fptr => c_void_to_rectangle(cptr)
            area = fptr%calculatearea()
        end function

        subroutine showinfo_circle(cptr) bind(c)
            type(c_ptr), intent(inout) :: cptr
            type(Circle_t), pointer :: fptr
            fptr => c_void_to_circle(cptr)
            call fptr%showinfo()
        end subroutine
        subroutine showinfo_rectangle(cptr) bind(c)
            type(c_ptr), intent(inout) :: cptr
            type(Rectangle_t), pointer :: fptr
            fptr => c_void_to_rectangle(cptr)
            call fptr%showinfo()
        end subroutine

        subroutine delete_circle_ptr(cptr) bind(c)
            type(c_ptr), intent(inout) :: cptr
            type(Circle_t), pointer :: fptr
            if( .not. c_associated(cptr)) return
            call c_f_pointer(cptr, fptr)
            deallocate(fptr)
            cptr = c_null_ptr
        end subroutine
        subroutine delete_rectangle_ptr(cptr) bind(c)
            type(c_ptr), intent(inout) :: cptr
            type(Rectangle_t), pointer :: fptr
            if( .not. c_associated(cptr)) return
            call c_f_pointer(cptr, fptr)
            deallocate(fptr)
            cptr = c_null_ptr
        end subroutine
end module