# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/dwz"
SRC_URI="https://sourceware.org/ftp/dwz/releases/${P}.tar.xz"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i -e '/^CFLAGS/d' Makefile || die
	tc-export CC
}
