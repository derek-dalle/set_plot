

Basic Plotting and Formatting
=============================

.. testsetup::
    
    # Prep modules
    import sys, os
    # Full path to the test folder
    docpath = os.path.join(os.getcwd(), "set_plot")
    # Now actually go to the current folder.
    os.chdir(docpath)
    # Load the module.
    from matlabtest import *
    
This test checks basic :func:`set_plot` usage and creates the various "peaks"
contour plots.
    
.. doctest::

    >>> matlab("test_peaks")
    "...PASSED\n"


