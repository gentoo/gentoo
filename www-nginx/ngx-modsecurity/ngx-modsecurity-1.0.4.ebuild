# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ModSecurity-nginx"

inherit nginx-module

DESCRIPTION="ModSecurity v3 NGINX Connector"
HOMEPAGE="
	https://github.com/owasp-modsecurity/ModSecurity-nginx
	https://modsecurity.org/
	https://github.com/owasp-modsecurity/ModSecurity
"
SRC_URI="
	https://github.com/owasp-modsecurity/ModSecurity-nginx/releases/download/v${PV}/${MY_PN}-v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-v${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND="dev-libs/modsecurity"
RDEPEND="${DEPEND}"
