# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Manipulate and process PDB files using tools such as Perl, awk, etc"
HOMEPAGE="https://www.ks.uiuc.edu/Development/MDTools/pdbcat/"
SRC_URI="https://www.ks.uiuc.edu/Development/MDTools/${PN}/files/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND=">=dev-build/cmake-3.31"

DOCS=( README )

PATCHES=( "${FILESDIR}"/${P}-gcc.patch )

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt . || die

	cmake_src_prepare
}
