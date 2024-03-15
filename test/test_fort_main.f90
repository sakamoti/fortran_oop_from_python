program test_fort_main
    use, intrinsic :: iso_fortran_env , only : dp => real64
    use m_shape, only : IShape, Circle_t, Rectangle_t, ShapeFactory, &
                        test_circle_area, test_rectangle_area
    class(IShape),allocatable :: circle, rectangle
    class(IShape),allocatable :: circle_array(:), rectangle_array(:)
    integer :: i

    !! test
    call test_circle_area()
    call test_rectangle_area()

    !! scalar
    circle = ShapeFactory(radius=3d0)
    rectangle = ShapeFactory(width=2d0, height=3d0)
    !! show information
    print '("#--- scalar version ---")'
    call circle%showinfo()
    call rectangle%showinfo()

    !! generate class array like python's zip method
    allocate(circle_array, source = ShapeFactory(radius=[1d0,2d0,3d0]))
    allocate(rectangle_array, source = ShapeFactory(width=[1d0,2d0,3d0], height=[4d0,5d0,6d0]))
    !! show informations
    print '("#--- array version ---")'
    do i = 1, size(circle_array)
        print '("  -- array(",I0,") ---")',  i
        call circle_array(i)%showinfo()
        call rectangle_array(i)%showinfo()
    end do
end program