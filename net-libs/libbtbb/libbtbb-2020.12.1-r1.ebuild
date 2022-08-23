# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library to decode Bluetooth baseband packets"
HOMEPAGE="https://github.com/greatscottgadgets/libbtbb"

if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/greatscottgadgets/libbtbb.git"
	inherit git-r3
else
	MY_PV=${PV/\./-}
	MY_PV=${MY_PV/./-R}
	SRC_URI="https://github.com/greatscottgadgets/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_PV}
	KEYWORDS="amd64 arm x86"
fi

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-2020.12.1-musl-u-char.patch
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_PYTHON=OFF
		-DBUILD_STATIC_LIB=$(usex static-libs)
	)
	cmake_src_configure
}
