# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libspatialindex/libspatialindex-1.8.0.ebuild,v 1.3 2013/06/25 12:57:40 ago Exp $

EAPI=5

inherit autotools eutils

MY_PN="spatialindex-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General framework for developing spatial indices"
HOMEPAGE="http://libspatialindex.github.com/"
SRC_URI="http://download.osgeo.org/libspatialindex/${MY_P}.tar.bz2"
LICENSE="MIT"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="debug static-libs"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-QA.patch
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
