# Copyright 1999-2022 Gentoo Authors
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
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/boost:="
RDEPEND="${DEPEND}"

src_configure() {
	cp "${WORKDIR}"/components-${PV}.cif data/components.cif || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCIFPP_BUILD_TESTS="$(usex test)"
	)
	cmake_src_configure
}
