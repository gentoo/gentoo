# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit multilib toolchain-funcs

MY_P=${PN}_${PV}

DESCRIPTION="Pidgin plugin that renders latex formulae"
HOMEPAGE="http://sourceforge.net/projects/pidgin-latex/"
SRC_URI="mirror://sourceforge/pidgin-latex/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

COMMON_DEPEND="
	net-im/pidgin[gtk]
	x11-libs/gtk+:2"
DEPEND="${COMMON_DEPEND}
	sys-devel/libtool
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	app-text/dvipng"

S=${WORKDIR}/${PN}

src_prepare() {
	sed -e "s:\(CC.*=\).*:\1 $(tc-getCC):" \
		-e "/LIB_INSTALL_DIR/{s:/lib/pidgin:/$(get_libdir)/pidgin:;}" \
			-i Makefile || die
}

src_install() {
	emake PREFIX="${D}/usr" install
	dodoc README CHANGELOG TODO
}

pkg_postinst() {
	elog 'Note, to see formulas either disable "Conversation Colors" plugin or'
	elog 'switch off "ignore incoming format" option in plugin configuration.'
	elog 'For details, take a look (and vote) at http://developer.pidgin.im/ticket/2772'
}
