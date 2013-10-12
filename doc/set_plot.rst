
***************
Plot Formatting
***************
    
MATLAB's plotting functions have become very popular, and yet there are some
basic deficiencies.  The main problems (and some ways to correct when
applicable) are listed below.  How to address them using :mod:`set_plot` is also
shown.

    #. When saved to PDF, graphics are always printed to a standard letter-sized
       sheet of paper.
       
        - A traditional fix to this is to save to EPS and then convert the
          graphic to PDF later.
        - Because MATLAB does a better job of creating EPS (Encapsulated
          PostScript) than PDF (Portable Document Format), this can be a good
          idea anyway.
        - This is always corrected when :func:`set_plot` is called.
    
    #. Graphics are normally saved to very large figures, with the result that
       text is difficult to read when scaled down to appropriate dimensions for
       publication.
       
        - This is very challenging to fix properly.
        - Many :mod:`set_plot` ``FigureStyle``\ s correct this automatically.
        - It can be set explicitly by setting the ``'Width'`` key.
        
    #. It is difficult to change the fonts to Serif style for publications that
       prefer figure text to be in that form.
       
        - In :mod:`set_plot`, the ``'FontStyle'`` key allows easy access to
          this.
          
    #. The color schemes are often inappropriate for conversion to grayscale.
    
        - The :mod:`set_plot` package provides extensive tools for setting
          colors.  In the simplest case, setting the ``'ColorStyle'`` key to
          ``'gray'`` will produce grayscale graphics directly.
          
    #. Once a graphics object (e.g., a line, a contour map, etc.) is created,
       it's difficult to find the handle again if it needs to be changed.
       
        - If :func:`set_plot` is called with an output, it will collect all of
          the handles found in the figure into categories.
      
Inputs
======

The basic usage of the :func:`set_plot` function is to give the function a
figure handle and a list of options.  For example, the following creates a
contour plot and then applies some formatting to it.
       
    .. code-block:: matlabsession
    
        >> h_f = figure
        >> contour(peaks(50))
        >> set_plot(h_f, 'FigureStyle', 'journal')
        
    .. image:: ./test/set_plot/peaks-journal.*
        :width: 300pt
            
It is possible to specify as many key name value pairs as you would like. 

    .. code-block:: matlabsession
    
        >> set_plot('FigureStyle', 'journal', 'ContourStyle', 'fancy')
        
    .. image:: ./test/set_plot/peaks-fancy.*
        :width: 300pt
        
Furthermore, if you have a series of figures to which you want to apply the same
(or similar) settings, there is another convenient input format.

    .. code-block:: matlabsession
    
        >> keys.FigureStyle = 'journal';
        >> keys.ContourStyle = 'fancy';
        >> keys.ColorMap = 'reverse-jet';
        >> keys.FontStyle = 'presentation';
        >> set_plot(h_f, keys)

    .. image:: ./test/set_plot/peaks-keys.*
        :width: 300pt
        

        
Cascading Styles
================

The :mod:`set_plot` packages uses a system of cascading styles (similar to CSS)
in which some of the format specifiers are children of others.  From the
previous examples, you may have figured out that ``'FigureStyle'`` is the parent
style that sets a general theme for the figure.  In fact, there is no setting
that is not affected by ``'FigureStyle'``.  However, if you specify a value for
a key that is a child of ``'FigureStyle'``, the manually selected value
overrides the one set by ``'FigureStyle'``.  As a concrete example, the command

    .. code-block:: matlabsession
    
        >> set_plot('FigureStyle', 'journal', 'ContourStyle', 'fancy')
        
    .. image:: ./test/set_plot/peaks-fancy.*
        :width: 300pt
        
uses a ``'ContourStyle'`` of ``'fancy'``, not the default ``'FigureStyle',
'journal'`` value of ``'pretty'``.

    
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
   
Detailed Documentation
======================

.. toctree::
   :maxdepth: 2
   
   format_keys
   cascading_styles
