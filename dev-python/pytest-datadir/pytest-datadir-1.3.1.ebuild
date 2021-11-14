# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Pytest plugin for manipulating test data directories and files"
HOMEPAGE="https://github.com/gabrielcnr/pytest-datadir"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ppc64 ~riscv ~s390 x86"

RDEPEND="dev-python/pytest[${PYTHON_USEDEP}]"

distutils_enable_tests --install pytest

python_install_all() {
	distutils-r1_python_install

	# Do not install license to /usr
	rm "${D}/usr/LICENSE" || die
}
