# Copyright 1999-2020 Gentoo Authors
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
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/elfutils"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-util/dejagnu
	dev-libs/elfutils[utils]
)"

src_prepare() {
	default
	sed -e '/^CFLAGS/d' -i Makefile || die
	tc-export CC
}
