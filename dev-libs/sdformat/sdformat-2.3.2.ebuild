# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils versionator vcs-snapshot

DESCRIPTION="Simulation Description Format (SDF) parser"
HOMEPAGE="http://sdformat.org/"
SRC_URI="https://bitbucket.org/osrf/sdformat/get/${PN}$(get_major_version)_${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-libs/urdfdom
	dev-libs/tinyxml
	dev-libs/boost:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
S="${WORKDIR}/${PN}$(get_major_version)_${PV}"

src_configure() {
	local mycmakeargs=(
		"-DUSE_UPSTREAM_CFLAGS=OFF"
		"-DUSE_EXTERNAL_URDF=ON"
		"-DUSE_EXTERNAL_TINYXML=ON"
	)
	cmake-utils_src_configure
}
