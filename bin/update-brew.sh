#!/bin/bash

echo `date` ": Updating 'brew' and installing upgrades..."
/usr/local/bin/brew update && /usr/local/bin/brew upgrade
