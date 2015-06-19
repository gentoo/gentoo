# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/dwz/dwz-0.9.ebuild,v 1.1 2013/03/04 16:40:18 dev-zero Exp $

EAPI=5

DESCRIPTION="DWARF optimization and duplicate removal tool"
HOMEPAGE="http://sourceware.org/git/?p=dwz.git;a=summary"
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
