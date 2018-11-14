# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils toolchain-funcs

MY_PN="GIMP-Lensfun"

DESCRIPTION="A Gimp plugin to correct lens distortions"
HOMEPAGE="https://seebk.github.io/GIMP-Lensfun/"
SRC_URI="https://github.com/seebk/GIMP-Lensfun/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND="media-gfx/gimp
	media-gfx/exiv2
	>=media-libs/lensfun-0.3.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	if ! use openmp; then
		sed -i "s/-fopenmp//g" Makefile
	fi

	tc-export CXX
}

src_install() {
	exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
	doexe ${PN}
}
