
# nkr-ops

Ansible-scripts to deploy NKR index to remote machines and local development (vagrant).

## local development

```
clone https://github.com/CSCfi/nkr-ops
cd nkr-ops
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

### authentication in local dev

nkr-index BA credentials: nkr-index / nkr-index

nkr-proxy BA credentials: nkr-proxy / nkr-proxy
