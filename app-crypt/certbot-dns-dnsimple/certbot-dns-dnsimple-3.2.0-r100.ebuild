# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="DNSimple Authenticator plugin for Certbot (Let's Encrypt Client)"
HOMEPAGE="
	https://github.com/certbot/certbot
	https://pypi.org/project/certbot-dns-dnsimple/
	https://certbot-dns-dnsimple.readthedocs.io/en/stable/
	https://letsencrypt.org/
"

LICENSE="metapackage"
SLOT="0"

KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

# Meta package for transition
# No need to upgrade thanks to ">="
RDEPEND="
	>=app-crypt/certbot-${PV}-r100[certbot-dns-dnsimple]
"

pkg_postinst() {
	elog "This is a meta-package to help in transition to single package "
	elog "app-crypt/certbot."
	elog "It is advice to simply deselect this package and to emerge "
	elog "app-crypt/certbot[certbot-dns-dnsimple] for this module."
}
