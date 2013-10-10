
**********************
Color Conversion Tools
**********************
    
MATLAB comes with very few named colors.  Although any color that you can figure
out the RGB (red-green-blue) color values for can be used, it's not always
convenient to figure these out.  For example, 

    .. code-block:: matlab
    
        >> x = linspace(0, 5, 101);
        >> plot(x, sin(x), 'Color', [1,0.65,0])
    
plots a sine curve with an orange color.  An alternative using the function
:func:`html2rgb` is to use the following command.

    .. code-block:: matlab
    
        >> plot(x, sin(s), 'Color', html2rgb('Orange'))
    
This version of the code is somewhat longer, but easier to remember and much
easier to read.  In addition, wherever colors can be specified in
:mod:`set_plot` commands, they can always be given as names or RGB codes.  For
example, the ``colormap`` can be changed to an indigo-themed monochrome map
using the following command.

    .. code-block:: matlab
    
        >> contourf(peaks(50))
        >> set_colormap({'w', 'Indigo', 'k'})
    
See :func:`set_colormap` for more information about that command.

Functions
=========

.. function:: html2rgb(cname)

    Convert a named color *cname* (``char``) to an RGB code.
    
        .. code-block:: matlab
            
            rgb = html2rgb(cname)
            rgb = html2rgb(crgb)
    
    +---------+-------------------+------------------+
    | Input   | Purpose           | Type             |
    +=========+===================+==================+
    | *cname* | name of color     | ``char``         |
    +---------+-------------------+------------------+
    | *cgrb*  | RGB code          | ``[1x3 double]`` |
    +---------+-------------------+------------------+
    
    +----------+--------------------+------------------+
    | Output   | Purpose            | Type             |
    +==========+====================+==================+
    | *rgb*    | RGB color code     | ``[1x3 double]`` |
    +----------+--------------------+------------------+
    
    .. note::
        
        If a numeric input is given, it is simply returned.  This is the case to
        that the function does not produces errors when a valid RGB color is
        given as input.  Thus it always save to put :func:`html2rgb` around a
        color reference.
        
    .. note::
        
        Most of the colors available to this function are tabulated
        `here <http://www.w3schools.com/html/html_colornames.asp>`_.  In 
        addition, the standard MATLAB single-character colors (:code:`'w'`, 
        white; :code:`'k'`, black; :code:`'r'`, red; :code:`'y'`, yellow;
        :code:`'g'`, green; :code:`'c'`, cyan; :code:`'b'`, blue; and
        :code:`'m'`, magenta) are also recognized.
    
Examples
========

This example demonstrates the usual output of :func:`html2rgb`.
    
    .. code-block:: matlab
    
        >> html2rgb('DodgerBlue')
        ans =
            0.1176    0.5647    1.0000
            
Shorter names are also available.

    .. code-block:: matlab
    
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
