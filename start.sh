#!/bin/bash
usermod -u ${PUID} ${CONT_USER} > /dev/null 2>&1
groupmod -g ${PGID} ${CONT_USER} > /dev/null 2>&1
su -s /bin/bash -c "${CONT_CMD}" ${CONT_USER}