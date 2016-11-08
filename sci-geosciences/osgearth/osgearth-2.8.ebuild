# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
	>=dev-games/openscenegraph-3.4[curl,qt5?]
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

src_configure() {
	# V8 disabled due to
	# https://github.com/gwaldron/osgearth/issues/333
	local mycmakeargs=(
		-DWITH_EXTERNAL_TINYXML=ON
		$(usex qt5 "-DOSGEARTH_USE_QT=ON" "-DOSGEARTH_USE_QT=OFF")
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
	if use doc ; then
		HTML_DOCS=("${S}"/docs/build/html/*)
	fi

	cmake-utils_src_install

	if use doc ; then
		doman "${S}"/docs/build/man/*
		doinfo "${S}"/docs/build/texinfo/*.info*
	fi
}
