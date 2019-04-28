# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

MY_P=${P/lib}

DESCRIPTION="ALSA driver C++ access library"
HOMEPAGE="http://packages.debian.org/libclalsadrv"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

RDEPEND="media-libs/alsa-lib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/lib}/libs"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	tc-export CXX
	emake
}

src_install() {
	emake LIBDIR="$(get_libdir)" PREFIX="${D}/usr" install
	dodoc ../AUTHORS
}
