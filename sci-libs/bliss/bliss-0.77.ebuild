# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

SRC_URI="https://users.aalto.fi/~tjunttil/${PN}/downloads/${P}.zip"
DESCRIPTION="Compute Automorphism Groups and Canonical Labelings of Graphs"
HOMEPAGE="https://users.aalto.fi/~tjunttil/bliss/index.html"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="gmp"

RDEPEND="gmp? ( dev-libs/gmp:0= )"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"
PATCHES=( "${FILESDIR}/${PN}-0.77-install.patch" )

src_configure() {
	local mycmakeargs=(
		-DUSE_GMP="$(usex gmp)"
	)

	cmake_src_configure
}
