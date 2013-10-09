.. set_plot documentation master file, created by
   sphinx-quickstart on Mon Oct  7 10:17:47 2013.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

:code:`set_plot` Documentation
==============================

The purpose of :code:`set_plot` is to make the creation of high-quality graphics
in MATLAB easier.  This documentation provides many examples for creating a
variety of functions in addition to a discussion of the options for the
functions.

The main function, :code:`set_plot`\ , uses a system of cascading
style options, similar to CSS.  This prevents the need to change many options
individually for customized graphics styles, but can be somewhat confusing.
Thus this documentation also includes a guide to what format options are
children of other options, and what happens when apparently conflicting options
are given to :code:`set_plot`.

Basic Examples
--------------

Consider the following MATLAB commands to create a simple contour plot.
::
	
	>> contour(peaks(50))
	
The resulting graphic, saved as a PNG, is below.

.. image:: ./pics/peaks-plain.png
    :width: 300pt
    
Displayed as such a small graphic, the graphic is almost unreadable.
Furthermore, saving to PDF produces the following (including whitespace), which
is not at all the expected result.

.. image:: ./pics/peaks-page.*
    :width: 300pt

Running :code:`set_plot` on this figure with no options produces no visible
changes to the MATLAB figure window, but results in properly saved PDF files.
::
	
	>> set_plot(gcf)

The following is the resulting image if saved as a PDF.

.. image:: ./pics/peaks-simple.*
    :width: 300pt

If we specify some non-default options to :code:`set_plot`, there is lots of
automatic formatting that is done.
::
	
	>> set_plot(gcf, 'FigureStyle', 'journal')
	
.. image:: ./pics/peaks-journal.*
    :width: 300pt

    
Contents
========

.. toctree::
   :maxdepth: 2
   
   intro
   html2rgb
   testing



Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

