# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python API and tools to manipulate OpenDocument files"
HOMEPAGE="https://github.com/eea/odfpy https://pypi.org/project/odfpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

distutils_enable_tests pytest

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
	distutils-r1_python_install_all
}
