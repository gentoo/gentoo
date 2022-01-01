# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="Code to work with mmCIF and PDB files"
HOMEPAGE="https://github.com/PDB-REDO/libcifpp"
SRC_URI="
	https://github.com/PDB-REDO/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	ftp://ftp.wwpdb.org/pub/pdb/data/monomers/components.cif.gz -> components-${PV}.cif.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-libs/boost-1.70.0:0=[threads(+)]
"
DEPEND=""
RDEPEND=""

src_configure() {
	mkdir data || die
	cp "${WORKDIR}"/components-${PV}.cif data/components.cif || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DUSE_RSRC=OFF
		-DCIFPP_BUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}
