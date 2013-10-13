
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

Plotting Lines
--------------

In an attempt to make lines in a plot more distinguishable, many
:func:`set_plot` commands change the appearance of lines automatically.  For
example the ``'journal'`` **FigureStyle** changes lines to alternate among solid
lines, dashed lines, and dot-dashed lines.  The ``'color'`` **FigureStyle**
makes all of the lines solid and instead varies the colors.

However, this behavior is not always desirable, especially if there is a data
set that is represented by data points and not a continuous curve.  Consider the
following example.

    .. code-block:: matlabsession
        
        >> x1 = linspace(0, 1, 101);
        >> x2 = linspace(0, 1, 8);
        >> hold('on')
        >> plot(x1, sinc(x1))
        >> plot(x1, 5*x1*(0.75-x1)
        >> plot(x2, sinc(x2) - (x2-0.5).^2, '^')
        
    .. image:: ./test/set_plot/lines-plain.*
        :width: 300pt
    
Note that since the three were plotted independently, they all default to the
default style (``'b-'``) except where explicitly overridden.  An application of
:func:`set_plot` to this gives the following.

    .. code-block:: matlabsession
    
        >> set_plot('FigureStyle', 'fancy', 'Width', 3.1)
        
    .. image:: ./test/set_plot/lines-fancy.*
        :width: 300pt
        
All of the MATLAB ``line`` objects are found, but only lines that have a
``'LineStyle'`` (that is, other than ``'none'``) are affected.  As a result, any
data series that are plotted without connecting lines are ignored.  In addition,
the lines are given alternating colors according to the value of the
:mod:`set_plot` parameter **ColorSequence**.

    .. note::
    
        Prior to ``set_plot`` version 0.9.0, all data series were affected, such
        that the blue triangles would have been joined using the code from the
        preceding example.
        
Furthermore, since :func:`set_plot` defaults to leaving things unchanged, it is
possible to change a low-level plot format setting with a single command.

    .. code-block:: matlabsession
    
        >> set_plot('LineWidth', 2)
        
    .. image:: ./test/set_plot/lines-clean.*
        :width: 300pt
        
    .. note::
        
        Prior to ``set_plot`` version 0.9.0, this format key was called
        ``'PlotLineWidth'``.  For compatibility, newer versions still recognize
        this longer key name.  The parameter ``'PlotLineStyle'`` is recognized
        for similar reasons.
        
However, if you have put hard work into manually picking the style for your
lines, and you would still like to utilize the other features of
:func:`set_plot`, there is a solution for that as well.
        
    .. code-block:: matlabsession
    
        >> plot(x1, x1, 'Color', [0.4,0,0.8], 'LineWidth', 2)
        >> plot(x1, 4*x1.*(1-x1), 'Color', [0.8,0.6,0.1], 'LineWidth', 2)
        >> set_plot('FigureStyle','journal', 'PlotStyle','current', 'ColorStyle','current')
    
    .. image:: ./test/set_plot/polys-clean.*
        :width: 300pt

    .. note::
        
        The **PlotStyle** must be set to ``'current'`` to keep the current line
        styles and widths, and the **ColorStyle** controls the colors of the
        lines.  In some previous versions of ``set_plot``, the **ColorStyle**
        portion of the command may not be necessary, and this may require
        changes to your code.


Working with Color Bars
-----------------------

The :mod:`set_plot` package is set up to work with the MATLAB ``colorbar``
object.  The following example shows some typical formatting that is applied to
color bars.

    .. code-block:: matlabsession
    
        >> [x, y] = meshgrid(linspace(-1, 1, 101));
        >> contourf(x, y, sin(2*pi*x) + sin(2*pi*y));
        >> colorbar
        >> set_plot('FigureStyle','journal', 'ContourStyle','fill');
        
    .. image:: ./test/set_plot/cbar-journal.*
        :width: 300pt
        
    .. code-block:: matlabsession
    
        >> set_plot('FigureStyle','fancy', 'ContourStyle','fill')
        
    .. image:: ./test/set_plot/cbar-fancy.*
        :width: 300pt
   
Detailed Documentation
======================

.. toctree::
   :maxdepth: 2
   
   format_keys
   cascading_styles
