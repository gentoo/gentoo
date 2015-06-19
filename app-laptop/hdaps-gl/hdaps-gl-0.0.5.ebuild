# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/hdaps-gl/hdaps-gl-0.0.5.ebuild,v 1.6 2011/10/12 09:45:32 chainsaw Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="OpenGL visualization for HDAPS data"
HOMEPAGE="http://hdaps.sourceforge.net"
SRC_URI="mirror://sourceforge/hdaps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/freeglut"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-as-needed.diff"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	dobin ${PN}
}
