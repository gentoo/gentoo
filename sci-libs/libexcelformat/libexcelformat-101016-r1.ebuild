# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="reading, writing, and editing of XLS (BIFF8 format) files using C++"
HOMEPAGE="https://www.codeproject.com/Articles/42504/ExcelFormat-Library"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/libExcelFormat"

LICENSE="CPOL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

PATCHES=( "${FILESDIR}"/${P}-Wliteral-suffix.patch )

src_configure() {
	tc-export CXX
}

src_install() {
	doheader *.h*
	dolib.so libExcelFormat.so*
}
