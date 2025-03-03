# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NS1 DNS Authenticator plugin for Certbot (Let’s Encrypt Client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://pypi.org/project/certbot-dns-nsone/
	https://letsencrypt.org/
"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="~amd64 ~x86"

# Meta package for transition
# Not worth the upgrade, keep only for Certbot release 3.2.0
RDEPEND="
	=app-crypt/certbot-${PV}-r100[certbot-dns-nsone]
"
