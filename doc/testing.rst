

Named Colors: :code:`html2rgb`
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
    
Here is some text.

.. doctest::

    >>> matlab("test_Navy")
    '0.5020'

.. doctest::

    >>> matlab("fprintf('3')")
    '3'

Did it work?
