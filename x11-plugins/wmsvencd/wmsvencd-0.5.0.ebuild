# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmsvencd/wmsvencd-0.5.0.ebuild,v 1.12 2014/07/22 20:32:37 mrueg Exp $

inherit eutils

DESCRIPTION="Window Maker Dockable CD-Player with CDDB"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

DEPEND="
	x11-wm/windowmaker
	x11-libs/libXpm"
RDEPEND="${DEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/wmsvencd-compile.patch

	sed -i 's:c++ -o:c++ $(LDFLAGS) -o:' Makefile
}

src_compile() {
	emake CFLAGS="${CFLAGS} -fno-strength-reduce" || die "make failed"
}

src_install() {
	newman wmsvencd.1x wmsvencd.1
	dobin wmsvencd
	dodoc README

	domenu "${FILESDIR}"/${PN}.desktop
}
