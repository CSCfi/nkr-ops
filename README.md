
# nkr-ops

Ansible-scripts to deploy NKR back end components to remote machines or a
local or remote development environment.

In testing/production, the components are deployed on separate servers.
For development, all the components are deployed on the same machine (local
virtual machine or remote server).

In case Python 3 is not yet installed on managed nodes, consider using [this
playbook](https://github.com/CSCfi/ansible-provision-python3) for provisioning
python3 first.

## Local development environment with Vagrant

After cloning this repo, you need to get the project secrets and edit
`ansible/secrets/local_development.yml` accordingly. After that you can run the
following to create and connect to the development VM.

```bash
vagrant up
vagrant ssh
```

Edit your local `/etc/hosts` file to add:

```bash
10.30.30.30 nkr-index.csc.local
10.30.30.30 nkr-proxy.csc.local
```

Then, solr ui at: nkr-index.csc.local
And authz proxy at: nkr-proxy.csc.local

## Development on a remote server

After cloning the repo, work in the `ansible/` directory.

First, edit `secrets/local_development.yml` and change the following:

```yml
devserver_ip: <public IP of your development server>
devserver_user: cloud-user
devserver_connection: ssh
```

Then run the playbooks with:

```bash
ansible-playbook -i inventories/local_development/hosts -e @./secrets/local_development.yml --private-key <path_to_your_keyfile> site_provision.yml
```

You can do the same edits to `/etc/hosts` as above, with the IP of your
Pouta instance.

## Authentication in local dev

nkr-index BA credentials: nkr-index / nkr-index

nkr-proxy BA credentials: nkr-proxy / nkr-proxy
