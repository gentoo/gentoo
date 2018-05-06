# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils toolchain-funcs

MY_PN="gimplensfun"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Gimp plugin to correct lens distortions"
HOMEPAGE="https://seebk.github.io/GIMP-Lensfun/"
SRC_URI="http://lensfun.sebastiankraft.net/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openmp"

RDEPEND="media-gfx/gimp
	media-gfx/exiv2
	media-libs/lensfun"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch

	if ! use openmp; then
		sed -i "s/-fopenmp//g" Makefile
	fi

	tc-export CXX
}

src_install() {
	exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
	doexe ${MY_PN}
}
