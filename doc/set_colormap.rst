
***********************
Color Map Customization
***********************
    
Consider the default color scheme produced using a MATLAB contour plot.

    .. code-block:: matlabsession
    
        >> contourf(peaks(51))
        >> colorbar
        >> set_plot
        
    .. image:: ./test/set_colormap/peaks-jet.*
        :width: 300pt
        
This is called the ``'jet'`` color scheme, and it is widely recognized.
However, it is often desirable to use a different color scheme.  A simple
example is to reverse the color scheme, which can be done with a single command.

    .. code-block:: matlabsession
    
        >> set_colormap reverse-jet
        
    .. image:: ./test/set_colormap/peaks-reverse.*
        :width: 300pt
        
Often it's appropriate to use a monochrome color scheme if the figure will be
published in black and white.

    .. code-block:: matlabsession
    
        >> set_colormap('Blue')
        
    .. image:: ./test/set_colormap/peaks-blue.*
        :width: 300pt
        
Monochrome color maps are extremely easy to make with :func:`set_colormap`.  Any
single color will produce a map ranging from white to that color, with the
exception of the colors ``'Red'``, ``'Yellow'``, ``'Green'``, ``'Cyan'``,
``'Blue'``, ``'Magenta'``, and ``'Black'``, which have more highly customized
sequences of colors.  The following example shows how to construct a color map
using only one color specification.

    .. code-block:: matlabsession
    
        >> set_colormap('DarkSalmon')
        
    .. image:: ./test/set_colormap/peaks-mono.*
        :width: 300pt
        
This is always equivalent to manually specifying white and then the color, and
serves as a minor shortcut.  In other words, the above is the same as

    .. code-block:: matlabsession
    
        >> set_colormap({'w', 'DarkSalmon'})
        
It's possible to construct a map out of any number of colors.  For example, a
bichromic scale is often useful for highlighting negative and positive regions
of a contour plot.

    .. code-block:: matlabsession
    
        >> set_colormap({[0.7,0.2,0.1], 'w', 'DarkTurquoise'})
    
    .. image:: ./test/set_colormap/peaks-bi.*
        :width: 300pt
        
Since the ``peaks`` data set has different minimum and maximum values, the
preceding example did not actually line up the white with zero.  To fix that,
you have to determine where zero is on the current color axis.

    .. code-block:: matlabsession
    
        >> v = caxis;
        >> t = -v(1) / (v(2) - v(1));
        >> set_colormap({0, 'DarkOrange'; t, 'w'; 1, 'Indigo'})
        
    .. image:: ./test/set_colormap/peaks-fix.*
        :width: 300pt
        
By putting white twice in a row in the color map description, it is possible to
highlight certain regions even more.  For example, this only fills in the
contours for positive values.

    .. code-block:: matlabsession
        
        >> set_colormap({0, 'w'; t, 'w'; 1, 'Teal'})
        
    .. image:: ./test/set_colormap/peaks-dead.*
        :width: 300pt
        
