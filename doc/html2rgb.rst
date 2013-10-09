

Named Colors: :code:`html2rgb`
==============================

.. testsetup:: *

    from subprocess import call
    def matlab(cmd):
        call(["matlab", "-nodesktop", "-nosplash", (
            "-r \"try,%s,end;exit\"" % cmd)])
        return None

Here is some text.

.. doctest::

    >>> matlab("3")
    ...
    ans =
         3

Did it work?
