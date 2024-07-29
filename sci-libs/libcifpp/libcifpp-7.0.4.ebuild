# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Code to work with mmCIF and PDB files"
HOMEPAGE="https://github.com/PDB-REDO/libcifpp"
# Update components file on every bump
# https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz
SRC_URI="
	https://github.com/PDB-REDO/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${P}-components.cif.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-cpp/eigen-3.4.0:3
	dev-libs/boost:=
	sys-libs/zlib
	test? ( dev-cpp/catch:0 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	# https://github.com/PDB-REDO/libcifpp/issues/59
	sed -i -e '/unit-3d/d' test/CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	cp "${WORKDIR}"/${P}-components.cif rsrc/components.cif || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCIFPP_INSTALL_UPDATE_SCRIPT=OFF
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}
