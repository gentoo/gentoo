# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Code to work with mmCIF and PDB files"
HOMEPAGE="https://github.com/PDB-REDO/libcifpp"
# Update components file on every bump
# https://files.wwpdb.org/pub/pdb/data/monomers/components.cif.gz
SRC_URI="
	https://github.com/PDB-REDO/libcifpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${P}-components.cif.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples sqlite test"
# https://github.com/PDB-REDO/libcifpp/issues/75
REQUIRED_USE="
	examples? ( sqlite )
	test? ( sqlite )
"

RESTRICT="!test? ( test )"

DEPEND="
	>=dev-cpp/eigen-3.4.0:3
	dev-libs/boost:=
	dev-libs/libpcre2
	virtual/zlib:=
	sqlite? ( dev-db/sqlite:3 )
	test? ( dev-cpp/catch:0 )
"
RDEPEND="${DEPEND}"

src_configure() {
	cp "${WORKDIR}"/${P}-components.cif rsrc/components.cif || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCIFPP_INSTALL_UPDATE_SCRIPT=OFF
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_SQLITE_INTERFACE="$(usex sqlite)"
		-DBUILD_TESTING="$(usex test)"
	)
	cmake_src_configure
}
