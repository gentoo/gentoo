# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/dwz"
SRC_URI="https://sourceware.org/ftp/dwz/releases/${P}.tar.xz"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/elfutils"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-libs/elfutils[utils]
	dev-util/dejagnu
	dev-debug/gdb
)"

src_prepare() {
	default
	sed -e '/^CFLAGS/d' -i Makefile || die
	tc-export CC
}
