# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_token/mod_auth_token-1.0.6_beta.ebuild,v 1.5 2014/08/10 20:14:27 slyfox Exp $

EAPI=3

inherit apache-module eutils

MY_P="${PN}-${PV/_/-}"
DESCRIPTION="Token based URI access module for Apache2"
HOMEPAGE="http://code.google.com/p/mod-auth-token/"
SRC_URI="http://mod-auth-token.googlecode.com/files/${MY_P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

APACHE2_MOD_CONF="75_${PN}"
APACHE2_MOD_DEFINE="AUTH_TOKEN"

need_apache2_2

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ap_pstrcat.patch
}

src_compile() {
	local flag=
	APXS2_ARGS=

	for flag in ${CFLAGS}; do
		APXS2_ARGS+=" -Wc,${flag}"
	done

	for flag in ${LDFLAGS}; do
		APXS2_ARGS+=" -Wl,${flag}"
	done

	APXS2_ARGS="${APXS2_ARGS} -c ${PN}.c"
	apache-module_src_compile
}
