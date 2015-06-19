# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/spu-tools/spu-tools-2.2.80_p95.ebuild,v 1.3 2008/12/26 14:46:52 josejx Exp $

MY_P=${P/_p/-}

DESCRIPTION="CELL spu ps and top alike utilities"
HOMEPAGE="http://sourceforge/projects/libspe"
SRC_URI="mirror://sourceforge/libspe/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ppc64"
IUSE=""

DEPEND="sys-libs/ncurses
		sys-apps/help2man"
RDEPEND="sys-libs/ncurses"

S="${WORKDIR}/${PN}/src"

src_compile() {
	emake all || die "emake failed"
}

src_install() {
	make DESTDIR="$D" install || die
}
