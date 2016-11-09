# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="http://i3wm.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/i3/i3"
EGIT_BRANCH="next"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc"

CDEPEND="dev-lang/perl
	dev-libs/libev
	dev-libs/libpcre
	>=dev-libs/yajl-2.0.3
	x11-libs/libxcb[xkb]
	x11-libs/libxkbcommon[X]
	x11-libs/startup-notification
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	>=x11-libs/pango-1.30.0[X]
	>=x11-libs/cairo-1.14.4[X,xcb]"
DEPEND="${CDEPEND}
	doc? ( app-text/asciidoc app-text/xmlto )
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS"

src_prepare() {
	default

	if ! use doc ; then
		sed -e '/AC_PATH_PROG(\[PATH_ASCIIDOC/d' -i configure.ac || die
	fi
	eautoreconf

	cat <<- EOF > "${T}"/i3wm
		#!/bin/sh
		exec /usr/bin/i3
	EOF
}

src_configure() {
	local myeconfargs=( --enable-debug=no )  # otherwise injects -O0 -g
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C "${CBUILD}"
}

src_install() {
	emake -C "${CBUILD}" DESTDIR="${D}" install
	einstalldocs

	exeinto /etc/X11/Sessions
	doexe "${T}"/i3wm
}

pkg_postinst() {
	einfo "There are several packages that you may find useful with ${PN} and"
	einfo "their usage is suggested by the upstream maintainers, namely:"
	einfo "  x11-misc/dmenu"
	einfo "  x11-misc/i3status"
	einfo "  x11-misc/i3lock"
	einfo "Please refer to their description for additional info."
}
