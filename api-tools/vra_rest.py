from __future__ import print_function
import os
import sys
import json
import tempfile
import subprocess
import getpass
import logging.config
import yaml

DEFAULT_VRA_HOST = "vcac-be.eng.vmware.com"
DEFAULT_TENANT = "qe"
DEFAULT_USERNAME = "fritz"
DEFAULT_PASSWORD = "VMware1!"
DEFAULT_ACCEPT = "application/json"

logger = logging.getLogger("vra_rest")

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

def initVarsForCurl():
    """ Prompts and initializes bash variables to easily use curl with vRA APIs

    The user is prompted for variables to use to call REST API. The bash 'export' commands are
    printed to standard output so you can execute the script using `eval $(python vra_rest.py)`.
    Prompts and output messages are sent to standard error.
    """
    host = promptWithDefault("vRA Host", DEFAULT_VRA_HOST)
    tenant = promptWithDefault("vRA Tenant", DEFAULT_TENANT)
    username = promptWithDefault("vRA Username", DEFAULT_USERNAME)
    password = promptWithDefault("vRA Password", DEFAULT_PASSWORD, secure=True)
    accept = promptWithDefault("ACCEPT", DEFAULT_ACCEPT)

    login = {
        "username" : username,
        "password" : password,
        "tenant" : tenant,
    }

    curl = "curl --silent --insecure -H 'Accept: {accept}' -H 'Content-Type: application/json' --data '{data}' https://{host}/identity/api/tokens".format(
                    accept=accept, data=json.dumps(login), host=host)

    logger.debug("Executing curl statement: %s",  curl)
    outputJson = subprocess.check_output(curl, shell=True)

    outputDict = json.loads(outputJson) # load the bearer token JSON response to python dictionary
    logger.debug("Parsed JSON response: \n%s", json.dumps(outputDict, sort_keys=True, indent=4))
    bearerToken = outputDict["id"]

    # Print statements to set env vars appropriately
    print('export VRA="{}"'.format(host))
    print('export ACCEPT="{}"'.format(accept))
    print('export AUTH="Bearer {}"'.format(bearerToken.strip()))

    # Print example curl command that you can now run
    print('curl --silent --insecure -H "Accept: $ACCEPT" -H "Authorization: $AUTH" ' + 
          'https://$VRA/identity/api/tenants/{tenant}/directories | python -mjson.tool'.format(
               tenant=tenant), file=sys.stderr)

if __name__ == "__main__":
    logging.config.dictConfig(yaml.load(open('logging_config.yaml', 'r')))
    logger.debug("Initialized logging...")
    initVarsForCurl()
