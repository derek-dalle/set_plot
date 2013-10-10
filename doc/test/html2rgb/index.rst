

Named Colors: :func:`html2rgb`
==============================

.. testsetup::
    
    # Prep modules
    import sys, os
    # Full path to the test folder
    docpath = os.path.join(os.getcwd(), "test")
    # Add that path.
    sys.path.append(docpath)
    # Now actually go the current folder.
    os.chdir(docpath)
    os.chdir("html2rgb")
    # Load the module.
    from matlabtest import *
    
This test checks the blue component of an HTML color called :code:`'Navy'`.
    
.. doctest::

    >>> matlab("test_Navy")
    '0.5020'


