# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_PN="spatialindex-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General framework for developing spatial indices"
HOMEPAGE="https://libspatialindex.github.com/"
SRC_URI="http://download.osgeo.org/libspatialindex/${MY_P}.tar.bz2"
LICENSE="MIT"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="debug static-libs"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{QA,pkgconfig}.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable debug)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
