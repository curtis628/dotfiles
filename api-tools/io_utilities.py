from __future__ import print_function
import sys
import getpass

def promptWithDefault(prompt, default, secure=False):
    """ Prompts user for input, using 'default' if blank. Securely prompts user if 'secure' is true.

    This method also outputs prompt to stderr so that python program can be fed into the 'eval'
    command, to avoid copy/pasting output to setup environment variables.
    """
    print("{} [{}]: ".format(prompt, default), file=sys.stderr, end=""),
    if secure:
        value = getpass.getpass("") or default
    else:
        value = raw_input() or default
 
    return value
