# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Parameter and topology file editor and molecular mechanical simulator engine"
HOMEPAGE="https://parmed.github.io/ParmEd/html/index.html"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	# From Debian
	"${FILESDIR}/${PN}-4.3.1-openmm-tests.patch"
	"${FILESDIR}/${PN}-4.3.1-network-tests.patch"
)

distutils_enable_tests pytest

python_test() {
	# disable online tests and those needing rdkit
	local -x CI=true
	epytest -k 'not test_deserialize_integrator and not test_download and not test_optimized_reader and not test_delete_bond'
}
