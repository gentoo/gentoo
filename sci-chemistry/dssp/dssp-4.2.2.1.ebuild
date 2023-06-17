# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

DESCRIPTION="The protein secondary structure standard"
HOMEPAGE="https://swift.cmbi.umcn.nl/gv/dssp/ https://github.com/PDB-REDO/dssp"
SRC_URI="https://github.com/PDB-REDO/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-libs/boost:=[zlib]
	>=dev-libs/libmcfp-1.2.2
	>=sci-libs/libcifpp-5.0.8
"
DEPEND=""
RDEPEND="${BDEPEND}"

pkg_postinst() {
	if has_version "<=sci-chemistry/gromacs-2022"; then
		ewarn "DSSP > 3.0.x is not compatible with gmx do_dssp:"
		ewarn "https://gitlab.com/gromacs/gromacs/-/issues/4129"
		ewarn
		ewarn "Feel free to mask newer versions if needed."
	fi
}
