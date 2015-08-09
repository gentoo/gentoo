# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils

DESCRIPTION="Log4c is a library of C for flexible logging to files, syslog and other destinations"
HOMEPAGE="http://log4c.sourceforge.net/"
SRC_URI="mirror://sourceforge/log4c/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug doc examples +expat"

RDEPEND="media-gfx/graphviz
	expat? ( dev-libs/expat )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
}

src_configure() {
	local myconf
	myconf="${myconf} --disable-expattest"

	econf \
		$(use_enable doc doxygen) \
		$(use_enable debug) \
		$(use_enable expat) \
		${myconf} || die "configure failed"
}

src_compile() {
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README TODO

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins -r examples/*
	fi
}
