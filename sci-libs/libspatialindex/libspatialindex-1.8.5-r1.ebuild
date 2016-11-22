# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

MY_PN="spatialindex-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="General framework for developing spatial indices"
HOMEPAGE="https://libspatialindex.github.com/"
SRC_URI="http://download.osgeo.org/libspatialindex/${MY_P}.tar.bz2"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0/4"
IUSE="debug static-libs"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.1-QA.patch
)

src_prepare() {
	default
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
