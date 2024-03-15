module m_shape
    use, intrinsic :: iso_c_binding, only : c_double
    real(c_double),parameter,public :: PI = 3.14159265358979323846d0
    private
    public test_circle_area, test_rectangle_area

    !! --- Begin interface -----------------------------------------
    type,abstract,public :: IShape
        !! Interface representing a generic shape.
        character(len=:),private,allocatable :: mytype
    contains
        !! abstractmethods
        procedure(IcalculateArea),pass,deferred,public :: calculatearea
        procedure(Ishowinfo),pass,deferred,public :: showinfo
    end type

    abstract Interface
        pure elemental function IcalculateArea(self) result(area)
            import IShape, c_double
            class(IShape),intent(in) :: self
            real(kind=c_double) :: area
            !! Caluculate the area of the shape.
            !!
            !! Returns
            !! -------
            !! c_double 
            !!     Area of the shape.
        end function
        subroutine Ishowinfo(self)
            import IShape
            class(IShape) :: self
            !! Show information.
        end subroutine
    end Interface
    !! --- End interface ------------------------------------------

    type,extends(IShape),public :: Circle_t
        real(c_double),private :: radius
    contains
        procedure :: calculatearea => calculatearea_circle
        procedure :: showinfo => showinfo_circle
    end type

    type,extends(IShape),public :: Rectangle_t
        real(c_double),private :: width, height
    contains
        procedure :: calculatearea => calculatearea_rectangle
        procedure :: showinfo => showinfo_rectangle
    end type

    !! Factory definithion ------
    public ShapeFactory
    interface ShapeFactory
        procedure :: circle__init__, rectangle__init__
    end interface

    !! private functions and subroutines
    contains
        !! ==================================================================
        !! methods
        pure elemental function circle__init__(radius) result(res)
            real(kind=c_double),intent(in) :: radius
            type(Circle_t) :: res
            res%mytype = "Circle_t"
            res%radius = radius
        end function
        pure elemental function calculatearea_circle(self) result(area)
            class(Circle_t),intent(in) :: self
            real(kind=c_double) :: area
            area = PI * self%radius ** 2
        end function
        subroutine showinfo_circle(self)
            class(Circle_t) :: self
            print *, "【 Hello from Fortran showinfo method 】"
            print *, "   type   : ",self%mytype
            print *, "   radius : ",self%radius
            print *, "   area   : ",self%calculatearea()
        end subroutine

        pure elemental function rectangle__init__(width, height) result(res)
            real(kind=c_double),intent(in) :: width, height
            type(Rectangle_t) :: res
            res%mytype = "Rectangle_t"
            res%width = width
            res%height = height
        end function
        pure elemental function calculatearea_rectangle(self) result(area)
            class(Rectangle_t),intent(in) :: self
            real(kind=c_double) :: area
            area = self%width * self%height
        end function
        subroutine showinfo_rectangle(self)
            class(Rectangle_t) :: self
            print *, "【 Hello from Fortran showinfo method 】"
            print *, "   type   : ",self%mytype
            print *, "   width  : ",self%width
            print *, "   height : ",self%height
            print *, "   area   : ",self%calculatearea()
        end subroutine

        !! ==================================================================
        !! tests
        subroutine test_circle_area()
            class(IShape),allocatable :: circle
            circle = ShapeFactory(radius=3d0)
            if ( abs(circle%calculatearea() - 3d0*3d0*PI) > 1d-8)then
                error stop "test_circle_area"
            end if
        end subroutine
        subroutine test_rectangle_area()
            class(IShape),allocatable :: rect
            rect = ShapeFactory(width=3d0,height=3d0)
            if ( abs(rect%calculatearea() - 3d0*3d0) > 1d-8)then
                error stop "test_circle_area"
            end if
        end subroutine
end module