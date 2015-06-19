# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/spatialite/spatialite-2.4.0_rc4.ebuild,v 1.5 2013/08/28 16:05:43 floppym Exp $

EAPI=4

MY_PV=${PV/_rc/-}
MY_P=lib${P/_rc*}

inherit multilib

DESCRIPTION="A complete Spatial DBMS in a nutshell built upon sqlite"
HOMEPAGE="http://www.gaia-gis.it/gaia-sins/"
SRC_URI="http://www.gaia-gis.it/${PN}-${MY_PV}/${MY_P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+geos iconv +proj"

RDEPEND=">=dev-db/sqlite-3.7.5:3[extensions(+)]
	geos? ( sci-libs/geos )
	proj? ( sci-libs/proj )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		--disable-static \
		--enable-geocallbacks \
		--enable-epsg \
		$(use_enable geos) \
		$(use_enable iconv) \
		$(use_enable proj)
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +
}
