# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gimp-lensfun/gimp-lensfun-0.2.2-r2.ebuild,v 1.2 2013/08/15 03:35:02 patrick Exp $

EAPI="4"

inherit eutils toolchain-funcs

MY_PN="gimplensfun"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Lensfun plugin for GIMP"
HOMEPAGE="http://lensfun.sebastiankraft.net/"
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
