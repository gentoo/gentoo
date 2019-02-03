# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FPKG_HASH="1624afa75b94633e03c6e1bb952fb348"

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/git/?p=dwz.git;a=summary"
SRC_URI="https://src.fedoraproject.org/repo/pkgs/dwz/${P}.tar.bz2/${FPKG_HASH}/${P}.tar.bz2"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/^CFLAGS/d' \
		Makefile || die "sed failed"
}
