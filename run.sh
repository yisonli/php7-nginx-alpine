#!/bin/sh


# Start supervisor
supervisord -c /etc/supervisord.conf --nodaemon 
