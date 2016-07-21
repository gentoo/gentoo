# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="https://sourceware.org/git/?p=dwz.git;a=summary"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-libs/elfutils"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^CFLAGS/d' \
		Makefile || die "sed failed"
}
