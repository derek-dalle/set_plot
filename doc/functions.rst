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
    
        
        
        
        
.. function:: set_plot(h_f[, keyName, keyVal])

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
            

