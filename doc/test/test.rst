

Testing for the testing system
==============================

.. testsetup::
    
    # Prep modules
    import sys, os
    # Full path to the test folder
    docpath = os.path.join(os.getcwd(), "test")
    # Add that path.
    sys.path.append(docpath)
    # Now actually go there.
    os.chdir(docpath)
    # Load the module.
    from matlabtest import *
    
This test simply determines if the testing module, :code:`matlabtest`\ , is
function properly.

.. doctest::

    >>> matlab("fprintf('3')")
    '3'


