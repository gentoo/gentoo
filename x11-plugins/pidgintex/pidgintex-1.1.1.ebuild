# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit toolchain-funcs multilib

MY_P=pidginTeX-${PV}

DESCRIPTION="Pidgin plugin to render LaTeX expressions in messages"
HOMEPAGE="http://code.google.com/p/pidgintex"
SRC_URI="http://pidgintex.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]
	app-text/mathtex"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -e "s:\(^CC.*=\).*:\1 $(tc-getCC):" \
		-e "s:\(^STRIP.*=\).*:\1 true:" \
		-e "s:\(^CFLAGS[[:space:]]*\)=:\1+=:" \
		-e "/LIB_INSTALL_DIR/{s:/lib/purple-2:/$(get_libdir)/pidgin:;}" \
			-i Makefile || die
	# set default renderer to mathtex
	sed -e "/purple_prefs_add_string.*PREFS_RENDERER/{s:mimetex:mathtex:;}" \
		-i pidginTeX.c || die
}

src_compile() {
	emake PREFIX=/usr || die
}

src_install() {
	make PREFIX="${D}/usr" install || die "make install failed"
	dodoc CHANGELOG README TODO || die
}

pkg_postinst() {
	elog 'Note, to see formulas either disable "Conversation Colors" plugin or'
	elog 'switch off "ignore incoming format" option in plugin configuration.'
	elog 'For details, take a look (and vote) at http://developer.pidgin.im/ticket/2772'
}
