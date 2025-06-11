# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Parsing Expressions with Strings, Complex Numbers, Vectors, Matrices and more"
HOMEPAGE="https://beltoforion.de/en/muparser/"
SRC_URI="https://github.com/beltoforion/muparserx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/muparserx-${PV}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-4.patch
)

src_configure() {
	# TODO: -DUSE_WIDE_STRING?
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
	)

	cmake_src_configure
}
