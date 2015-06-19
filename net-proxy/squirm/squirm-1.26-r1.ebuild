# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/squirm/squirm-1.26-r1.ebuild,v 1.3 2012/12/17 09:32:16 ago Exp $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A redirector for Squid"
HOMEPAGE="http://squirm.foote.com.au"
SRC_URI="http://squirm.foote.com.au/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="net-proxy/squid"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake CC="$(tc-getCC)" LDOPTS="${LDFLAGS}"
}

src_install() {
	emake PREFIX="${ED}/opt/squirm" install
}

pkg_postinst() {
	einfo "To enable squirm, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /opt/squirm/bin/squirm"
	einfo "    url_rewrite_children 10"
}
