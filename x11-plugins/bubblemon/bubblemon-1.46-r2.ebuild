# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/bubblemon/bubblemon-1.46-r2.ebuild,v 1.3 2012/05/05 05:12:00 jdhore Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A fun monitoring applet for your desktop, complete with swimming duck"
HOMEPAGE="http://www.ne.jp/asahi/linux/timecop"
SRC_URI="http://www.ne.jp/asahi/linux/timecop/software/${PN}-dockapp-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-dockapp-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gtk.patch \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-no_display.patch
}

src_compile() {
	tc-export CC
	emake GENTOO_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin bubblemon
	dodoc ChangeLog README doc/Xdefaults.sample

	insinto /usr/share/${PN}
	doins misc/*.{xcf,wav}
	exeinto /usr/share/${PN}
	doexe misc/wakwak.sh
}
