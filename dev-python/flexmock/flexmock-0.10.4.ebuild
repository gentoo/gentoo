# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="Testing library to create mocks, stubs and fakes"
HOMEPAGE="https://flexmock.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r docs
}
