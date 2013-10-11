
**********************
Color Conversion Tools
**********************
    
MATLAB comes with very few named colors.  Although any color that you can figure
out the RGB (red-green-blue) color values for can be used, it's not always
convenient to figure these out.  For example, 

    .. code-block:: matlabsession
    
        >> x = linspace(0, 5, 101);
        >> plot(x, sin(x), 'Color', [1,0.65,0])
    
plots a sine curve with an orange color.  An alternative using the function
:func:`html2rgb` is to use the following command.

    .. code-block:: matlabsession
    
        >> plot(x, sin(s), 'Color', html2rgb('Orange'))
    
This version of the code is somewhat longer, but easier to remember and much
easier to read.  In addition, wherever colors can be specified in
:mod:`set_plot` commands, they can always be given as names or RGB codes.  For
example, the ``colormap`` can be changed to an indigo-themed monochrome map
using the following command.

    .. code-block:: matlabsession
    
        >> contourf(peaks(50))
        >> set_colormap({'w', 'Indigo', 'k'})
    
See :func:`set_colormap` for more information about that command.

    
Examples
========

This example demonstrates the usual output of :func:`html2rgb`.
    
    .. code-block:: matlabsession
    
        >> html2rgb('DodgerBlue')
        ans =
            0.1176    0.5647    1.0000
            
Shorter names are also available.

    .. code-block:: matlabsession
    
        >> html2rgb('y')
        ans =
             1     1     0
        >> html2rgb('yellow')
        ans =
             1     1     0
             
Because valid RGB color codes are returned when input, the function can safely
be nested.

    .. code-block:: matlab
    
        >> html2rgb(html2rgb('Coral'))
        ans =
            1.0000    0.4980    0.3137
            
A single number as input is taken as grayscale.

    .. code-block:: matlabsession
    
        >> html2rgb(0.3)
        ans =
            0.3000    0.3000    0.3000
            

