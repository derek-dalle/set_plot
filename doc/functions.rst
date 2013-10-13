*********
Functions
*********

.. function:: html2rgb(cName)

    Convert a named color *cname* (``char``) to an RGB code.
    
        .. code-block:: matlab
            
            rgb = html2rgb(cBame)
            rgb = html2rgb(fRGB)
            rgb = hgml2rgb(iRGB)
            rgb = html2rgb(fGray)
            rgb = html2rgb(iGray)
    
    +---------+--------------------------+------------------+
    | Input   | Purpose                  | Type             |
    +=========+==========================+==================+
    | *cName* | name of color            | ``char``         |
    +---------+--------------------------+------------------+
    | *fRGB*  | RGB components, 0 to 1   | ``[1x3 double]`` |
    +---------+--------------------------+------------------+
    | *iRGB*  | RGB components, 0 to 255 | ``[1x3 double]`` |
    +---------+--------------------------+------------------+
    | *fGray* | grayscale, 0 to 1        | ``[1x1 double]`` |
    +---------+--------------------------+------------------+
    | *fRGB*  | grayscale, 0 to 255      | ``[1x1 double]`` |
    +---------+--------------------------+------------------+
    
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
            

.. function:: set_colormap(cmap)

    Alter and customize the ``colormap``.
    
        .. code-block:: matlab
            
            set_colormap(cmapName)
            set_colormap(cmapCell)
            set_colormap(cmapMat)
            set_colormap({colName1, colName2, ...})
            set_colormap({colVal1, colName1; ...})
            set_colormap(h_f, ...)
            cmap = set_colormap(...)
    
    +------------+----------------------------+------------------+
    | Input      | Purpose                    | Type             |
    +============+============================+==================+
    | *cmapName* | custom colormap name       | ``char``         |
    +------------+----------------------------+------------------+
    | *cmapCell* | colormap cell array        | ``cell``         |
    +------------+----------------------------+------------------+
    | *cmapMat*  | matrix of RGB colors       | ``[Nx3 double]`` |
    +------------+----------------------------+------------------+
    | *colName1* | color specifier            | varies           |
    +------------+----------------------------+------------------+
    | *colVal1*  | value (0 to 1) for color 1 | ``[1x1 double]`` |
    +------------+----------------------------+------------------+
    | *h_f*      | figure handle              | ``[1x1 double]`` |
    +------------+----------------------------+------------------+
    
    +----------+--------------------+------------------+
    | Output   | Purpose            | Type             |
    +==========+====================+==================+
    | *h*      | struct of handles  | ``struct``       |
    +----------+--------------------+------------------+
    
    The primary asset of the function is its ability to easily construct
    ``colormap``\ s by piecing together colors.  For example, to change the
    ``colormap`` to one that goes from pink for low values to green for high
    values, simply run the following command.
    
        .. code-block:: matlabsession
        
            >> set_colormap({'pink', 'green'})
            
    It's also convenient in cases where you want a specific color to correspond
    to a specific value.  For example, the following command will make the color
    pink 30% up the scale.
    
        .. code-block:: matlabsession
            
            >> set_colormap({0, 'Blue'; 0.3, 'Pink'; 1, 'Green'})
    
    .. note::
        
        The built-in color maps all available.  See the MATLAB documentation for
        :func:`colormap` for a list.  In other words, if ``colormap(cmapName)``
        works, then ``set_colormap(cmapName)`` will yield the same results.
        
    .. note::
        
        If a single color is given, a monochrome ``colormap`` ranging from white
        to that color will be made.  For the single-character colors, the
        automatic map instead goes from white to the color to black.
        
    .. note::
        
        All color maps can be reversed by prepending the title with
        ``'reverse-'``.  For example ``'reverse-jet'``.
    
        
        
.. function:: set_plot(h_f[, keyName, keyVal])

    Apply customized formatting to a figure.
    
        .. code-block:: matlab
            
            set_plot
            set_plot(keyName, keyValue, ...)
            set_plot(keys)
            set_plot(h_f, ...)
            h = set_plot(...)
    
    +------------+--------------------------+------------------+
    | Input      | Purpose                  | Type             |
    +============+==========================+==================+
    | *h_f*      | figure handle            | ``[1x1 double]`` |
    +------------+--------------------------+------------------+
    | *keyName*  | name of format key       | ``char``         |
    +------------+--------------------------+------------------+
    | *keyValue* | value of preceding key   | varies           |
    +------------+--------------------------+------------------+
    | *keys*     | struct of key values     | ``struct``       |
    +------------+--------------------------+------------------+
    
    +----------+--------------------+------------------+
    | Output   | Purpose            | Type             |
    +==========+====================+==================+
    | *h*      | struct of handles  | ``struct``       |
    +----------+--------------------+------------------+
    
    .. note::
        
        For a list of available format keys and values, see :ref:`format_keys`.
        
    .. note::
        
        For a list of cascading format keys and their effects, see
        :ref:`cascading-styles`.

.. function:: xtick_vertical(s_x[, h_a])

    Produce vertical tick labels on the *x*-axis
    
        .. code-block:: matlab
            
            xtick_vertical(s_x)
            xtick_vertical(s_x, h_a)
            h_t = xtick_vertical(...)
    
    +------------+----------------------------------+------------------+
    | Input      | Purpose                          | Type             |
    +============+==================================+==================+
    | *h_a*      | axis handle                      | ``[1x1 double]`` |
    +------------+----------------------------------+------------------+
    | *s_x*      | cell array of x-axis tick labels | ``cell``         |
    +------------+----------------------------------+------------------+
    
    +----------+--------------------+------------------+
    | Output   | Purpose            | Type             |
    +==========+====================+==================+
    | *h_t*    | tick label handle  | ``[1x1 double]`` |
    +----------+--------------------+------------------+
    
    

