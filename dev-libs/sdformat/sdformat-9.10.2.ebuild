# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"
inherit cmake ruby-single

DESCRIPTION="Simulation Description Format (SDF) parser"
HOMEPAGE="http://sdformat.org/"
SRC_URI="https://github.com/gazebosim/sdformat/archive/refs/tags/${PN}9_${PV}.tar.gz"

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
	${RUBY_DEPS}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}-${PN}9_${PV}"

src_prepare() {
	# use latest preferred ruby binary
	local RUBYEXEC=$(echo $RUBY_TARGETS_PREFERENCE | cut -d\  -f1) 
	sed -i -e "s:find_program(RUBY ruby):find_program(RUBY NAMES $RUBYEXEC ruby):" cmake/SearchForStuff.cmake

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
