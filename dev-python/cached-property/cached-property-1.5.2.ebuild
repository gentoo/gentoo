# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="A cached-property for decorating methods in classes"
HOMEPAGE="https://github.com/pydanny/cached-property"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~riscv x86"

DEPEND="test? ( dev-python/freezegun[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_prepare_all() {
	# bug 638250
	eapply "${FILESDIR}"/${PN}-1.5.1-test-failure.patch

	distutils-r1_python_prepare_all
}

python_install_all() {
	dodoc README.rst HISTORY.rst CONTRIBUTING.rst AUTHORS.rst
	distutils-r1_python_install_all
}
