# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rfcutil/rfcutil-3.2.3-r2.ebuild,v 1.5 2013/01/15 20:22:01 ulm Exp $

EAPI=4

inherit eutils prefix

MY_PN="rfc"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="return all related RFCs based upon a number or a search string"
HOMEPAGE="http://www.dewn.com/rfc/"
SRC_URI="http://www.dewn.com/rfc/${MY_P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="dev-lang/perl
	|| ( www-client/lynx virtual/w3m )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${MY_P}-paths.patch \
		"${FILESDIR}"/${MY_P}-index.patch
	eprefixify ${MY_P}
}

src_install() {
	newbin ${MY_P} ${MY_PN}
	doman ${MY_PN}.1
	dodoc CHANGELOG KNOWN_BUGS README
	keepdir /var/cache/rfc
}

pkg_postinst() {
	elog "Gaarde suggests you make a cron.monthly to run the following:"
	elog "   ${EPREFIX}/usr/bin/rfc -i"
}

pkg_prerm() {
	rm -f "${EROOT}"/var/cache/rfc/*
}
