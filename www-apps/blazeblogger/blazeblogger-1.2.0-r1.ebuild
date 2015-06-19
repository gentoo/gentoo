# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/blazeblogger/blazeblogger-1.2.0-r1.ebuild,v 1.2 2013/06/21 19:33:51 xmw Exp $

EAPI=4

inherit eutils

DESCRIPTION="simple-to-use, capable content management system for the cmdline producing static content"
HOMEPAGE="http://blaze.blackened.cz/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz
	doc? ( http://${PN}.googlecode.com/files/${PN}-doc-${PV}.tar.gz ) "

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e '/-m 644 COPYING/d' \
		-e '/-m 644 INSTALL/d' \
		-i Makefile || die

	epatch "${FILESDIR}"/${P}-bash-completion.patch #bug 417953
}

src_install() {
	emake prefix="${D}/usr" config="${D}/etc" \
		compdir="${D}/usr/share/bash-completion" install

	use doc && dohtml -r "${WORKDIR}"/${PN}-doc-${PV}/*
}
