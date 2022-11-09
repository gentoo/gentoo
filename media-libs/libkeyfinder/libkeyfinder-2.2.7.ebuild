# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Musical key detection library for digital audio"
HOMEPAGE="https://github.com/mixxxdj/libkeyfinder"
SRC_URI="https://github.com/mixxxdj/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

RDEPEND="
	sci-libs/fftw:3.0
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s/NAMES fftw /NAMES /" \
		cmake/FindFFTW3.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}
