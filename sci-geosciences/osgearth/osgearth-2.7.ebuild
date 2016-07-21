# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Dynamic map generation toolkit for OpenSceneGraph"
HOMEPAGE="http://osgearth.org/"
SRC_URI="https://github.com/gwaldron/osgearth/archive/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc qt5"

RDEPEND="
	dev-db/sqlite:3
	>=dev-games/openscenegraph-3.2.1-r1[curl,qt5?]
	dev-libs/protobuf
	dev-libs/tinyxml
	net-misc/curl
	sci-libs/gdal
	sci-libs/geos
	sys-libs/zlib[minizip]
	virtual/opengl
	x11-libs/libX11
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"

S=${WORKDIR}/${PN}-${P}

PATCHES=(
	"${FILESDIR}"/${PN}-2.6-cmake-options.patch
	"${FILESDIR}"/${PN}-2.7-linker.patch
)

src_configure() {
	# V8 disabled due to
	# https://github.com/gwaldron/osgearth/issues/333
	local mycmakeargs=(
		-DWITH_EXTERNAL_TINYXML=ON
		$(cmake-utils_use qt5 OSGEARTH_USE_QT)
		-DUSE_V8=OFF
		-DOSGEARTH_USE_JAVASCRIPTCORE=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C "${S}"/docs man html info
	fi
}

src_install() {
	cmake-utils_src_install

	if use doc ; then
		dohtml -r "${S}"/docs/build/html/*
		doman "${S}"/docs/build/man/*
		doinfo "${S}"/docs/build/texinfo/*.info*
	fi
}
