# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ar ast be bg bs ca ca@valencia cs da de el en_GB eo es et eu fi fr
ga gl hi hne hr hu is it ja km lt mai mr nb nds nl nn pa pl pt pt_BR ro ru se sk
sv tr ug uk vi zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE Photo Album is a tool for indexing, searching, and viewing images"
HOMEPAGE="http://www.kphotoalbum.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2+ FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug +exif +face +geolocation +kipi +map +raw"

REQUIRED_USE="map? ( exif )"

COMMON_DEPEND="
	>=dev-qt/qtsql-4.4:4[sqlite]
	media-libs/phonon[qt4]
	virtual/jpeg:0
	exif? ( >=media-gfx/exiv2-0.17:= )
	face? ( >=kde-apps/libkface-15.08.3:4 )
	geolocation? ( $(add_kdeapps_dep marble) )
	kipi? ( $(add_kdeapps_dep libkipi '' 4.9.58) )
	map? ( >=kde-apps/libkgeomap-15.08.3:4 )
	raw? ( $(add_kdeapps_dep libkdcraw '' 4.9.58) )
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	media-video/mplayer
	kipi? ( >=media-plugins/kipi-plugins-4.7.0:4 )
"

DOCS=( ChangeLog README )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with exif Exiv2)
		$(cmake-utils_use_with face Kface)
		$(cmake-utils_use_with geolocation Marble)
		$(cmake-utils_use_with kipi)
		$(cmake-utils_use_with map KGeoMap)
		$(cmake-utils_use_with raw Kdcraw)
	)

	kde4-base_src_configure
}
