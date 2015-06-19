# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/i3/i3-9999.ebuild,v 1.9 2015/03/26 14:14:23 xarthisius Exp $

EAPI=5

inherit eutils toolchain-funcs git-2

DESCRIPTION="An improved dynamic tiling window manager"
HOMEPAGE="http://i3wm.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/i3/i3"
EGIT_BRANCH="next"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+pango"

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
	pango? (
		>=x11-libs/pango-1.30.0[X]
		>=x11-libs/cairo-1.12.2[X,xcb]
	)"
DEPEND="${CDEPEND}
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	dev-perl/AnyEvent-I3
	dev-perl/JSON-XS"

src_prepare() {
	if ! use pango; then
		sed -i common.mk -e '/PANGO/d' || die
	fi

	cat <<- EOF > "${T}"/i3wm
		#!/bin/sh
		exec /usr/bin/i3
	EOF

	epatch_user #471716
}

src_compile() {
	emake V=1 CC="$(tc-getCC)" AR="$(tc-getAR)"
	emake mans
}

src_install() {
	default
	dohtml -r docs/*
	doman man/*.1
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
