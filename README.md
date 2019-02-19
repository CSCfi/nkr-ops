
# nkr-ops

Ansible-scripts to deploy NKR index to remote machines and local development (vagrant).

## local development

```
clone https://github.com/CSCfi/nkr-ops
cd nkr-ops
mkdir nkr-proxy
cd ansible
./install_requirements.sh
cd -
vagrant up
vagrant ssh
```

Edit your local /etc/hosts file to add:

```
30.30.30.30 nkr-index.csc.local
30.30.30.30 nkr-proxy.csc.local
```

Then, solr ui at: nkr-index.csc.local
And authz proxy at: nkr-proxy.csc.local
