# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/regex-markup/regex-markup-0.10.0.ebuild,v 1.4 2012/06/20 12:23:18 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="A tool to color syslog files as well"
HOMEPAGE="http://www.nongnu.org/regex-markup/"
SRC_URI="http://savannah.nongnu.org/download/regex-markup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="examples nls"

src_prepare() {
	epatch "${FILESDIR}"/${P}-locale.patch
}

src_configure() {
	econf \
		--enable-largefile \
		$(use_enable nls)
}

src_install() {
	default
	if use examples; then
		cd examples
		emake -f Makefile
	fi
}
