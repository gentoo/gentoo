# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/fbset/fbset-2.1.ebuild,v 1.35 2012/07/10 08:50:50 flameeyes Exp $

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="A utility to set the framebuffer videomode"
HOMEPAGE="http://users.telenet.be/geertu/Linux/fbdev/"
SRC_URI="http://users.telenet.be/geertu/Linux/fbdev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="static"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-build.patch"
}

src_compile() {
	use static && append-ldflags -static
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin fbset modeline2fb || die "dobin failed"
	doman *.[58]
	dodoc etc/fb.modes.* INSTALL
}
