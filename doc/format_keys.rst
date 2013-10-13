.. _format_keys:

List of Format Keys
===================

    **AspectRatio**: [ {``'auto'``} | *positive scalar* ]
        Aspect ratio to use for rigure.  The ``'auto'`` option tells the
        function to use the aspect ratio of the current figure window.
        
    **AxesStyle**: [ {``'current``'} | ``'pretty'`` | ``'fancy'`` | ``'simple'`` | ``'smart'`` | ``'plain'`` ]
        Scheme to use for axes.  This is a cascading style.


    **BarColorStyle**: [ {``'current'``} | ``'contour'`` | ``'sequence'`` ]
        Whether to use the colormap or the color sequence for the colors
        of bar graph objects.
        
    **Box**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to draw a box around the plot.
        
    **ColorBarStyle**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'plain'`` ]
        Style to use for colorbar.  This is a cascading style.
        
    **ColorBarBox**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to draw a box around the colorbar.
        
    **ColorBarMinorTick**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to use minor ticks on the colorbar.
        
    **ColorBarTickDir**: [ {``'current'``} | ``'in'`` | ``'out'`` ]
        Direction to draw ticks on the colorbar
        
    **ColorBarWidth**: [ {``'current'``} | *positive scalar* ]
        Width of colorbar, not including labels and ticks.
        
    **ColorBarGrid**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to draw grid lines in the colorbar.
        
    **ColorBarGridLineStyle**: [ {``'current'``} | ``':`` | ``'-'`` | ``'--'`` | ``'-.'`` ]
        Style for grid lines in colorbar.
        
    **ColorBarGap**: [ {``0.1``} | *positive scalar* ]
        Distance between box containing plot and box containing colorbar.
        
    **ColorMap**: [ {``'current'``} | *char* | *N×3 double* | *N×4 double* | *cell* ]
        The colormap can consist of either a label to a standard MATLAB
        colormap or use a matrix of colors.  An additional option is to use
        a cell array of colors.  Each color can be either a 1×3 RGB color or
        an HTML color string such as ``'OliveGreen'``.  See :func:`set_colormap`.

    **ColorSequence**: [ {``'current'``} | ``'plain'`` | ``'gray'`` | ``'black'`` | ``'blue'`` | ``'dark'`` | ``'bright'`` | *Nx3 matrix* | *cell* ]
        Sequence of colors for plot lines.
        
    **ColorStyle**: [ {``'current'``} | ``'pretty'`` | ``'plain'`` | ``'gray'`` | ``'bright'`` | ``'dark'`` ]
        Overall color theme.  This is a cascading style.
        Color to use for labels in contour plots
        
    **ContourFill**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not contours plots should be filled in.
        
    **ContourFontColor**: [ {``'current'``} | ``'auto'`` | *char* | *1x3 double* ]
        Color to use for contour text labels.  The ``'auto'`` value chooses
        either black or white for each label in an attempt to pick a color
        that is readable against the background.
        
    **ContourFontName**: [ {``'current'``} | ``'auto'`` | *char*]
        Font to use for contour text labels.  The ``'auto'`` value
        inherits the overall font specified using FontName.
        
    **ContourFontSize**: [ {``'current'``} | ``'auto'`` | *positive scalar* ]
        Size of font to use for contour text labels.  The ``'auto'`` value
        corresponds to a size one point smaller than the overall font
        size specified using FontSize.
        
    **ContourLineColor**: [ {``'current'``} | ``'auto'`` | *char* | *1x3 double* ]
        Color to use for contour lines.  The ``'auto'`` value tells the
        function to match the contour lines to the colormap values.
        
    **ContourLineStyle**: [ {``'current'``} | ``'-'`` | ``'none'`` | ``'--'`` | ``'-.'`` | ``':'`` ]
        Style to use for contour lines.
        
    **ContourStyle**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'black'`` | ``'fill'`` | ``'smooth'`` | ``'simple'`` | ``'plain'`` ]
        Style to use for contour plots.  This is a cascading style.
        
    **ContourText**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to use labels in contour plots.
        
    **FigureStyle**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'plain'`` | ``'journal'`` | ``'twocol'`` | ``'onecol'`` | ``'present'`` | ``'presentation'`` | ``'color'`` | ``'plot'`` ]
        Overall figure style.  This is a cascading style.
        
    **FontName**: [ {``'current'``} | *char* ]
        Name of font to use for most text
        
    **FontSize**: [ {``'current'``} | *positive scalar* ]
        Size of fonts to use.
        
    **FontStyle**: [ {``'current'``} | ``'pretty'`` | ``'presentation'`` | ``'plain'`` | ``'serif'`` | ``'sans-serif'`` ]
        Scheme for text fonts and sizes.  This is a cascading style.
     

    **Grid**: [ {``'current'``} | ``'major'`` | ``'all'`` | ``'on'`` | ``'off'`` | ``'none'`` | ``'smart'`` | ``'x'`` | ``'y'`` | ``'z'`` | ``'X'`` | ``'Y'`` | ``'Z'`` ]
        Whether or not to draw grid lines.  The strings ``'x'``, ``'y'``, etc. and
        their combinations can be used to control the grid lines for each
        axis.  The capital versions turn on both major and minor grid lines.
        The ``'smart'`` value turns on all major grid lines and minor grid lines
        for any axis with linear spacing.
        
    **Interpreter**: [ {``'current'``} | ``'auto'`` | ``'tex'`` | ``'latex'`` | ``'none'`` ]
        Rules to use for text interpreters.  The ``'auto'`` option turns most
        interpreters to ``'tex'``, except those with multiple ``'$'`` characters,
        for which it uses the ``'latex'`` interpreter.
        
    **LegendBox**: [ {``'current'``} | ``'on'`` | ``'off'`` ]
        Whether or not to use a box around the legend.
        
    **LegendGap**: [ {``0.1``} | *positive scalar* ]
        Gap between graph and legend.
        
    **LegendStyle**: [ {``'current'``} | ``'plain'`` | ``'pretty'`` ]
        Style to use for the legend.  This is a cascading style.
        
    **LineStyle**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'simple'`` | ``'plain'`` | *cell* ]
        Sequence of plot styles.  The name **PlotLineStyle** also maps to this
        parameter.
        
    **LineWidth**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'simple'`` | ``'plain'`` | *cell* | *double* ]
        Sequence of widths for plot lines.  Names **PlotLineWidth** and **lw**
        also map to this parameter.
        
    **Margin**: [ {``0.025``} | *scalar double* | *1×4 double* ]
        Extra margin to add for ``'tight'`` MarginStyle.
        
    **MarginBottom**: [ {``0.025``} | *positive scalar* ]
        Extra bottom margin to add for ``'tight'`` MarginStyle.
        
    **MarginLeft**: [ {``0.025``} | *positive scalar* ]
        Extra left margin to add for ``'tight'`` MarginStyle.
        
    **MarginRight**: [ {``0.025``} | *positive scalar* ]
        Extra right margin to add for ``'tight'`` MarginStyle.
        
    **MarginStyle**: [ {``'tight'``} | ``'loose'`` | ``'image'`` ]
        Style for the margins.  The ``'tight'`` option cuts off all margins, and
        the ``'loose'`` option restores the defaults.  Both options change the
        paper size so that the figure has the proper dimensions when the
        :func`saveas` command is used.
        
    **MarginTop**: [ {``0.025``} | *positive scalar* ]
        Extra top margin to add for ``'tight'`` MarginStyle.
        
    **MinorTick**: [ {``'current'``} | ``'all'`` | ``'none'`` | ``'smart'`` | ``'x'`` | ``'y'`` | ``'z'`` | ``'xy'`` | ``'xz'`` | ``'yz`` ]
        Whether or not to use minor ticks on the axes.  The ``'smart'``
        value turns on minor ticks for all non-logarithmic axes.
        
    **PlotStyle**: [ {``'current'``} | ``'pretty'`` | ``'fancy'`` | ``'plain'`` ]
        Style to use for plot lines.  This is a cascading style.
        
    **TickDir**: [ {``'current'``} | ``'in'`` | ``'out'`` ]
        Tick direction for main plot.
        
    **TickLength**: [ {``'current'``} | ``'short'`` | ``'long'`` | *1x2 double* ]
        Length of ticks for main axes.
        
    **Width**: [ {``'auto'``} | *positive scalar* ]
        Width of figure.
      
