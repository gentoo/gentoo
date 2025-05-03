# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A C++ implementation of a memory efficient hash map and hash set"
HOMEPAGE="https://github.com/Tessil/sparse-map"
COMMIT="1bc4561e5a267c0ae0e1e543ba64e7436946a765"
SRC_URI="https://github.com/Tessil/sparse-map/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"

src_configure() {
	cmake_src_configure
}

src_install() {
	cmake_src_install
}
