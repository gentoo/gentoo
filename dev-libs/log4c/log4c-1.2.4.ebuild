# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="Log4c is a library of C for flexible logging to files, syslog and other destinations"
HOMEPAGE="http://log4c.sourceforge.net/"
SRC_URI="mirror://sourceforge/log4c/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples +expat static-libs"

RDEPEND="expat? ( dev-libs/expat )"
DEPEND="${RDEPEND}
	doc? ( 	app-doc/doxygen[dot] )"

PATCHES=( "${FILESDIR}/${P}-docdir.patch" )

src_configure() {
	local myeconfargs=(
		--disable-expattest
		$(use_enable debug)
		$(use_enable doc)
	)

	use expat || myeconfargs+=( --without-expat )

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}
