# Self configuring LDAP (in a box)

This repository provides the tools to build and use a self contain OpenLDAP instance.

It doesn't provide much security and shouldn't be used where security is a requirement.

## Configuration

Copy the `conf.example.env` as `conf.env`, and set the values according to your needs.

> Note the format of the base domain has to be in LDAP notation. (`dc=example,dc=fr` if your organisation is example.fr)

> Also note that the dc needs to be the last subdomain name of your base.

## How to backup/restore

Use the `backup.sh` script. It will populate a `dump` directory on here with the 0th and 1st databases of the running ldap, as well as its `slapd.conf`.

The contents of `dump` can then be saved to a proper backup for safekeeping.

To restore, use the `restore.sh` script. It only needs the `dump` directory --as populated by the first script-- and the `docker-compose.yml` files to work.
