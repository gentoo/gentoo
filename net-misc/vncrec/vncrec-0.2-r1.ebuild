# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vncrec/vncrec-0.2-r1.ebuild,v 1.2 2012/09/28 18:43:28 ago Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="VNC session recorder and player"
HOMEPAGE="http://www.sodan.org/~penny/vncrec/"
SRC_URI="http://www.sodan.org/~penny/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/gccmakedep
	x11-misc/imake
	x11-proto/xextproto"

DOCS=( README README.vnc )

src_prepare() {
	epatch "${FILESDIR}"/${P}-includes.patch
	touch vncrec/vncrec.man || die
	sed -i Imakefile \
		-e '/make Makefiles/d' \
		|| die "sed Imakefile"
}

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CXXFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		World
}
