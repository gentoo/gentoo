# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs vcs-snapshot

MY_COMMIT_HASH="a8f618cf1bf92279b43c7b737010fd7e42c8e5d3"

DESCRIPTION="Pidgin plugin to render LaTeX expressions in messages"
HOMEPAGE="https://github.com/Micket/pidgintex"
SRC_URI="https://github.com/Micket/${PN}/archive/${MY_COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="net-im/pidgin[gtk]
	app-text/mathtex
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -e "s:\(^CC.*=\).*:\1 $(tc-getCC):" \
		-e "s:\(^STRIP.*=\).*:\1 true:" \
		-e "s:\(^CFLAGS[[:space:]]*\)=:\1+=:" \
		-e "/LIB_INSTALL_DIR/{s:/lib/purple-2:/$(get_libdir)/pidgin:;}" \
			-i Makefile || die
	# set default renderer to mathtex
	sed -e "/purple_prefs_add_string.*PREFS_RENDERER/{s:mimetex:mathtex:;}" \
		-i pidginTeX.c || die

	if ! use nls; then
		sed -e '/ENABLE_NLS = 1/ d;' -i Makefile || die
	fi

	default
}

src_compile() {
	emake PREFIX=/usr
}

src_install() {
	emake PREFIX="${ED%/}/usr" install
	einstalldocs
}

pkg_postinst() {
	elog 'Note, to see formulas either disable "Conversation Colors" plugin or'
	elog 'switch off "ignore incoming format" option in plugin configuration.'
	elog 'For details, take a look (and vote) at http://developer.pidgin.im/ticket/2772'
}
