# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to the Redmine REST API"
HOMEPAGE="
	https://github.com/maxtepkeev/python-redmine/
	https://pypi.org/project/python-redmine/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/requests-2.28.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	# https://github.com/maxtepkeev/python-redmine/pull/332
	sed -i -e 's:assertEquals:assertEqual:' tests/*.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -o addopts=
}
