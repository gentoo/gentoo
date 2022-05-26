# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit flag-o-matic toolchain-funcs wxwidgets

DESCRIPTION="A full-featured wxWidgets version of the classic dice game Yahtzee"
HOMEPAGE="http://openyahtzee.sourceforge.net/"
SRC_URI="mirror://sourceforge/openyahtzee/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"

pkg_pretend() {
	local ver=4.6
	local msg="You need at least GCC ${ver}.x for C++11 range-based 'for' and nullptr support."

	if tc-is-gcc ; then
		if ver_test ${ver} -gt $(gcc-version); then
			die ${msg}
		fi
	else
		ewarn "Ensure your compiler has C++11 support, otherwise build will fail."
	fi
}

src_configure() {
	append-cxxflags -std=c++11
	setup-wxwidgets
	econf --datadir=/usr/share
}
