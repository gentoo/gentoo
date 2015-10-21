# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="GDAL plugin to access GRASS data"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/gdal/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"

IUSE="postgres"

RDEPEND="
	>=sci-libs/gdal-2.0.0
	>=sci-geosciences/grass-7.0.1[gdal]
"
DEPEND="${RDEPEND}
	dev-libs/expat
	dev-libs/json-c
	virtual/jpeg
	media-libs/tiff
	sci-libs/libgeotiff
	sci-libs/proj
	sys-libs/zlib
	postgres? ( dev-db/postgresql )"

src_prepare() {
	# fix mkdir not called with -p in Makefile
	epatch "${FILESDIR}/gdal-grass-makefile.patch"
}

src_configure() {
	econf \
		--with-grass="${ROOT}/usr/$(get_libdir)/grass70" \
		--with-gdal="${ROOT}/usr/bin/gdal-config" \
		$(use_with postgres postgres-includes "${ROOT}/usr/include/postgresql")
}

src_install() {
	#pass the right variables to 'make install' to prevent a sandbox access violation
	emake DESTDIR="${D}" \
		GRASSTABLES_DIR="${D}$(gdal-config --prefix)/share/gdal/grass" \
		AUTOLOAD_DIR="${D}/usr/$(get_libdir)/gdalplugins" \
		install
}