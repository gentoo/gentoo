# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Small tool to report and change the keyboard LED states of an X display"
HOMEPAGE="https://github.com/bmeurer/xsetleds"
SRC_URI="
	ftp://ftp.unix-ag.org/user/bmeurer/xsetleds/src/${P}.tar.gz
	https://dev.gentoo.org/~jsmolic/distfiles/${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ppc sparc x86"

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
	"${FILESDIR}"/${P}-configure-implicit-function-decl.patch
)

src_configure() {
	tc-export CC

	default
}
