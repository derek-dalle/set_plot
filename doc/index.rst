.. set_plot documentation master file, created by
   sphinx-quickstart on Mon Oct  7 10:17:47 2013.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

:mod:`set_plot` Documentation
==============================

The purpose of :mod:`set_plot` is to make the creation of high-quality graphics
in MATLAB easier.  This documentation provides many examples for creating a
variety of functions in addition to a discussion of the options for the
functions.

The main function, :func:`set_plot`\ , uses a system of cascading
style options, similar to CSS.  This prevents the need to change many options
individually for customized graphics styles, but can be somewhat confusing.
Thus this documentation also includes a guide to what format options are
children of other options, and what happens when apparently conflicting options
are given to :func:`set_plot`.

    
Contents
========

.. toctree::
   :maxdepth: 3
   :numbered:
   
   functions
   set_plot
   set_colormap
   html2rgb
   test/index
   

Installation
============

To install the :mod:`set_plot` package, simply unzip the file to a good folder
(within the ``'Documents/MATLAB'`` folder is a pretty good suggestion) and run
the :func:`sp_Install` function.

    .. code-block:: matlabsession
    
        >> ierr = sp_Install
        ans =
             0
             
If the output of this command is zero, the installation was successful.
Afterwards, you may delete the ``.zip`` file, but do not delete the unzipped
folder.  To uninstall from MATLAB's memory, run the following command.

    .. code-block:: matlabsession
    
        >> sp_Uninstall
        
This does not delete the :mod:`set_plot` source from your computer, so you will
have to do that manually if desired.
        

Basic Examples
==============

Usage and Basic Plots
---------------------

This example illustrates the basic usage of :mod:`set_plot`\ .

    .. code-block:: matlabsession
    
        >> x = linspace(0, 6, 121);
        >> plot(x, sin(x), x, cos(x+sin(4*x))/2)
        >> xlabel('Time [s]')
        >> ylabel('Amplitude')
    
And, voilà, you get the following graphic.

    .. image:: ./test/set_plot/sine-plain.*
        :width: 300pt
        
Now, in a single command, :func:`set_plot` can change the fonts, point the axes
ticks outward instead of inward, and make several other changes.

    .. code-block:: matlabsession
    
        >> set_plot('FigureStyle', 'fancy')
        
The resulting figure, shown below, has many more bells and whistles.

    .. image:: ./test/set_plot/sine-fancy.*
        :width: 300pt
        
The idea is that running ``set_plot('FigureStyle', 'journal')`` will result in a
figure that is close to being presentable for publication.  Perhaps the most
useful aspect of this is creating a figure that is appropriately sized for
printing, which is discussed more in the following example. 


Figure Sizing and Saving to PDF
-------------------------------

Consider the following MATLAB commands to create a simple contour plot.

    .. code-block:: matlabsession
        
        >> contour(peaks(50))
	
The resulting graphic, saved as a PNG, is below.

    .. image:: ./test/set_plot/peaks-plain.png
        :width: 300pt
    
Displayed as such a small graphic, the graphic is almost unreadable.
Furthermore, saving to PDF produces the following (including whitespace), which
is not at all the expected result.

    .. image:: ./test/set_plot/peaks-page.*
        :width: 300pt

Running :code:`set_plot` on this figure with no options produces no visible
changes to the MATLAB figure window, but results in properly saved PDF files.

    .. code-block:: matlabsession
        
        >> set_plot(gcf)

The following is the resulting image if saved as a PDF.

    .. image:: ./test/set_plot/peaks-simple.*
        :width: 300pt

If we specify some non-default options to :code:`set_plot`, there is lots of
automatic formatting that is done.

    .. code-block:: matlabsession
        
        >> set_plot(gcf, 'FigureStyle', 'journal')
	
    .. image:: ./test/set_plot/peaks-journal.*
        :width: 300pt

.. note:: 
    As of version 0.9.0, resizing the MATLAB figure window does cause the figure
    to be resized, whereas in previous versions it would remain the same size,
    often occupying just the lower left-hand corner of the window.  However,
    this automatic resizing does not transfer to the ``'PaperSize'`` property,
    meaning that saving to a PDF will not work as expected if you have resized a
    window.


Indices and tables
==================

* :ref:`genindex`
* :ref:`search`

