# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="3V: Voss Volume Voxelator"
HOMEPAGE="http://geometry.molmovdb.org/3v/"
SRC_URI="http://geometry.molmovdb.org/3v/3v-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PDEPEND="sci-chemistry/msms-bin"
#	sci-chemistry/usf-rave"

S="${WORKDIR}/3v-${PV}/src"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CXX
	emake distclean || die
}

src_install() {
	emake DESTDIR="${ED}" install || die

	cd ..
	dodoc AUTHORS ChangeLog QUICKSTART README TODO VERSION || die
}
