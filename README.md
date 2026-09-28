# Expki.Umbrella

**WARNING: highly experimental application, don't use it in production**

`expki` is an experimental project created to manage self-signed certificates
with Elixir, including an API and a WUI. The story behind this project is not
really interesting, my infrastructure contains OpenVPN service, and the
certificates require maintenance.  The current way to deal with that is to use
`easy_rsa`, but the tool is kinda annoying and not really flexible. `expki`
would like to solve that.

Second reason, I was a bit rusty in Elixir, and I needed something to work on.

# Requirements

* elixir
* postgresql-server
* openssl or libressl

# Usage

```console
$ iex -S mix phx.server
```

# Test

```console
$ mix test
```

# Notes

All my reflexions and thoughts are stored in [`./notes`]()./notes directory.

# References and Resources

* https://github.com/Taylorwaldo/PKILab_OpenSSL-Experiments
* https://github.com/NDO4ME/Trustsslroot
* https://gist.github.com/xl-sec/a540d3bd230661ee1692a65185d8814c
* https://github.com/OpenVPN/easy-rsa
* https://easy-rsa.readthedocs.io/en/latest/
* https://community.openvpn.net/Pages/EasyRSA
* https://pki-tutorial.readthedocs.io/en/latest/
* https://www.redhat.com/en/blog/openssl-and-internet-pki
* https://docs.strongswan.org/docs/latest/pki/pki.html
* https://github.com/letsencrypt/boulder
* https://github.com/letsencrypt/boulder/blob/main/README.md
