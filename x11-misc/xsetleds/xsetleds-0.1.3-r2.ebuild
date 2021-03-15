# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="small tool to report and change the keyboard LED states of an X display"
HOMEPAGE="https://github.com/bmeurer/xsetleds"
SRC_URI="
	ftp://ftp.unix-ag.org/user/bmeurer/xsetleds/src/${P}.tar.gz
	https://dev.gentoo.org/~jer/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc ~sparc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
PATCHES=(
	"${FILESDIR}"/${P}-assignment.patch
	"${FILESDIR}"/${P}-isalpha.patch
)

src_prepare() {
	default
	tc-export CC
}

DOCS=( AUTHORS ChangeLog README TODO )
