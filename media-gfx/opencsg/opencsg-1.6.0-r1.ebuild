# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P="OpenCSG-${PV}"

DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="https://www.opencsg.org"
SRC_URI="https://www.opencsg.org/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0/1.6"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="doc"
RESTRICT="test"

DOCS=( build.txt changelog.txt )

PATCHES=( "${FILESDIR}"/${PN}-1.6.0-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLE=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use doc && local HTML_DOCS=( doc/. )
	einstalldocs
}
