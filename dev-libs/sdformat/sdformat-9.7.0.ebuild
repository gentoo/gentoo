# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Simulation Description Format (SDF) parser"
HOMEPAGE="http://sdformat.org/"
SRC_URI="http://osrf-distributions.s3.amazonaws.com/sdformat/releases/${P}.tar.bz2"

LICENSE="Apache-2.0"
# subslot = libsdformat major
SLOT="0/9"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/urdfdom-1:=
	dev-libs/tinyxml
	dev-libs/boost:=
	sci-libs/ignition-math:6=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/ruby:*
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare

	# get rid of default flags
	sed -i -e '/_FLAGS_RELWITHDEBINFO/d' cmake/DefaultCFlags.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_URDF=OFF
		-DUSE_EXTERNAL_TINYXML=ON
	)
	cmake_src_configure
}
