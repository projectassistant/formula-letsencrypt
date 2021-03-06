# Install required apt packages
letsencrypt_packages_apt:
  pkg.installed:
    - pkgs:
      - libffi-dev
      - python-dev
      # We need python-pip to be able to use to pip.installed saltstack state module
      - python-pip
      # We need lsof to solve the chicken-egg problem when requesting the first certificate when there is no webserver yet
      - lsof
      # We need this package to install the pip package "certbot"
      - libssl-dev

# Install virtualenv
letsencrypt_packages_pip_virtualenv:
  pip.installed:
    - name: virtualenv

# Install latest version of setuptools, pip install letsencrypt might fail otherwise
letsencrypt_packages_pip-setuptools:
  pip.installed:
    - name: setuptools
    - upgrade: True
    - bin_env: /opt/letsencrypt
    - use_vt: True
    - require:
      - virtualenv: letsencrypt_packages_virtualenv_/opt/letsencrypt

# Create a virtualenv for letsencrypt
letsencrypt_packages_virtualenv_/opt/letsencrypt:
  virtualenv.managed:
    - name: /opt/letsencrypt

# Install the python-pip package in the new virtualenv
letsencrypt_packages_pip-package:
  pip.installed:
    - name: letsencrypt
    - bin_env: /opt/letsencrypt
    - require:
      - virtualenv: letsencrypt_packages_virtualenv_/opt/letsencrypt
      - pip: letsencrypt_packages_pip-setuptools

