# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="https://swift.cmbi.umcn.nl/gv/dssp/ https://github.com/PDB-REDO/dssp"

COMMIT="728cc7c6c8d95460d8db453cf7adb25a89ba15f6"
SRC_URI="https://github.com/PDB-REDO/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	>=dev-libs/boost-1.70.0:=[bzip2,zlib,threads(+)]
	>=sci-libs/libcifpp-1.1.1
"
DEPEND=""
RDEPEND="${BDEPEND}"

pkg_postinst() {
	if has_version sci-chemistry/gromacs; then
		ewarn "DSSP > 3.0.x is not compatible with gmx do_dssp:"
		ewarn "https://gitlab.com/gromacs/gromacs/-/issues/4129"
		ewarn
		ewarn "Feel free to mask newer versions if needed."
	fi
}
