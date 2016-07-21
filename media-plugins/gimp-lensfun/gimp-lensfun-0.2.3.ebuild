# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

MY_PN="GIMP-Lensfun"

DESCRIPTION="Lensfun plugin for GIMP"
HOMEPAGE="http://seebk.github.io/GIMP-Lensfun/"
SRC_URI="https://github.com/seebk/GIMP-Lensfun/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

RDEPEND="media-gfx/gimp
	media-gfx/exiv2
	media-libs/lensfun"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-remove-deprecated-output.patch

	if ! use openmp; then
		sed -i "s/-fopenmp//g" Makefile
	fi

	tc-export CXX
}

src_install() {
	exeinto $(gimptool-2.0 --gimpplugindir)/plug-ins
	doexe ${PN}
}
