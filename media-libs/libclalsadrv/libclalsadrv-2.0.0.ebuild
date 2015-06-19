# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclalsadrv/libclalsadrv-2.0.0.ebuild,v 1.4 2012/01/20 22:43:49 ssuominen Exp $

EAPI=4
inherit eutils multilib toolchain-funcs

MY_P=${P/lib}

DESCRIPTION="ALSA driver C++ access library"
HOMEPAGE="http://packages.debian.org/libclalsadrv"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P/lib}/libs

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	tc-export CXX
	emake
}

src_install() {
	emake LIBDIR="$(get_libdir)" PREFIX="${D}/usr" install
	dodoc ../AUTHORS
}
