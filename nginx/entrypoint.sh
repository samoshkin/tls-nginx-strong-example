#!/bin/sh

set -eux

# Check nginx configuration
nginx -t

# Start nginx itself
exec "$@"