#!/bin/bash

echo "Installing Steampipe..."
sudo /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"

echo "Installing Powerpipe..."
sudo /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)"

echo "Installing AWS Plugin for Steampipe..."
steampipe plugin install aws

echo "Installation complete!"
