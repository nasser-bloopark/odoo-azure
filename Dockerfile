FROM odoo:15.0

USER root

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Set timezone in non interactive way
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get -y install tzdata


RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            wget \
            sudo \
            software-properties-common \
            nano \
            apt-utils

# Install requirements
RUN pip3 install --upgrade pip
COPY ./requirements.txt /requirements_custom.txt
RUN pip3 install -r /requirements_custom.txt

# Add custom files
ADD ./odoo.conf /etc/odoo/odoo.conf
ADD ./custom_addons /mnt/custom_addons

# Set the access
RUN chown -R odoo:odoo /odoo
RUN chown -R odoo:odoo /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo
