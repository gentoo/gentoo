# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Implements a protobuf-based interface for Spectrum2 python-based backends"
HOMEPAGE="https://github.com/stv0g/pyspectrum2"
SRC_URI="https://github.com/stv0g/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/protobuf-python[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_install_all() {
	distutils-r1_python_install_all

	python_optimize
}
