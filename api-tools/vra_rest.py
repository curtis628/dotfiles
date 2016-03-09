from __future__ import print_function
import os
import sys
import json
import tempfile
import subprocess
import logging.config
import yaml
import vra_defaults
from io_utilities import promptWithDefault

logger = logging.getLogger("vra_rest")

def initVarsForCurl():
    """ Prompts and initializes bash variables to easily use curl with vRA APIs

    The user is prompted for variables to use to call REST API. The bash 'export' commands are
    printed to standard output so you can execute the script using `eval $(python vra_rest.py)`.
    Prompts and output messages are sent to standard error.
    """
    host = promptWithDefault("vRA Host", vra_defaults.DEFAULT_VRA_HOST)
    tenant = promptWithDefault("vRA Tenant", vra_defaults.DEFAULT_TENANT)
    username = promptWithDefault("vRA Username", vra_defaults.DEFAULT_USERNAME)
    password = promptWithDefault("vRA Password", vra_defaults.DEFAULT_PASSWORD, secure=True)
    accept = promptWithDefault("ACCEPT", vra_defaults.DEFAULT_ACCEPT)

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
