# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"
inherit eutils wxwidgets toolchain-funcs versionator games

DESCRIPTION="A full-featured wxWidgets version of the classic dice game Yahtzee"
HOMEPAGE="http://openyahtzee.sourceforge.net/"
SRC_URI="mirror://sourceforge/openyahtzee/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.6
	dev-libs/boost"

pkg_pretend() {
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."
	if ! version_is_at_least ${ver} $(gcc-version); then
		eerror ${msg}
		die ${msg}
	fi
}

src_prepare() {
	# Debian patch that was upstreamed and accepted
	# This can be dropped on next version then
	epatch "${FILESDIR}"/${P}-wx3.0.patch
}

src_configure() {
	need-wxwidgets unicode
	egamesconf --datadir=/usr/share
}

src_install() {
	default
	prepgamesdirs
}
