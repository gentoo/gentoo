# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_PN="${MY_PN//-/_}"
DESCRIPTION="Backport of functools.lru_cache from Python 3.3"
HOMEPAGE="https://github.com/jaraco/backports.functools_lru_cache"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.9[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	if use test && has_version "${CATEGORY}/${PN}"; then
		die "Ensure $PN is not already installed or the test suite will fail"
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	PYTHONPATH=. py.test || die "tests failed with ${EPYTHON}"
}
