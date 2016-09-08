# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
WX_GTK_VER="3.0"
inherit eutils wxwidgets toolchain-funcs versionator

DESCRIPTION="A full-featured wxWidgets version of the classic dice game Yahtzee"
HOMEPAGE="http://openyahtzee.sourceforge.net/"
SRC_URI="mirror://sourceforge/openyahtzee/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.6
	dev-libs/boost"

pkg_pretend() {
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."

	if tc-is-gcc ; then
		if ! version_is_at_least ${ver} $(gcc-version); then
			die ${msg}
		fi
	else
		ewarn "Ensure your compiler has C++11 support, otherwise build will fail."
	fi
}

src_configure() {
	append-cxxflags -std=c++11
	need-wxwidgets unicode
	econf --datadir=/usr/share
}
