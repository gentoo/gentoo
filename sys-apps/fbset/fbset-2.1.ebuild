# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic eutils

DESCRIPTION="A utility to set the framebuffer videomode"
HOMEPAGE="http://users.telenet.be/geertu/Linux/fbdev/"
SRC_URI="http://users.telenet.be/geertu/Linux/fbdev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="static"

DEPEND="sys-devel/bison
	sys-devel/flex"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${P}-build.patch"
	epatch "${FILESDIR}/${P}-add-linux-types-h.patch"
	default
}

src_compile() {
	use static && append-ldflags -static
	tc-export CC
	emake
}

src_install() {
	dobin fbset modeline2fb
	doman *.[58]
	dodoc etc/fb.modes.* INSTALL
}
