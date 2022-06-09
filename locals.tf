locals {
  caddy_config = <<EOF
:80 {
        # tls liqianglau@outlook.com
        basicauth /* {
          admin ${base64encode(bcrypt(random_password.default.result))}
        }
        reverse_proxy /v2/ 127.0.0.1:5000 {
                header_up X-Forwarded-Proto {scheme}
                header_up X-Forwarded-For {host}
                header_up Host {host}
        }
}
EOF

  htpasswd_config = <<EOF
admin:${bcrypt(random_password.default.result)}
EOF

  registry_config = <<EOF
version: 0.1
storage:
  filesystem:
    rootdirectory: /var/lib/registry
    maxthreads: 100
auth:
  htpasswd:
    realm: basic-realm
    path: /etc/docker/registry/htpasswd
http:
  addr: 0.0.0.0:80
  relativeurls: false
  draintimeout: 60s
  headers:
    X-Content-Type-Options: [nosniff]
  http2:
    disabled: false
EOF

}
