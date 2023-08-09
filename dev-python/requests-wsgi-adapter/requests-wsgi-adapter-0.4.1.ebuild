# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

DESCRIPTION="WSGI Transport Adapter for Requests"
HOMEPAGE="
	https://pypi.org/project/requests-wsgi-adapter/
"
COMMIT_HASH="5b771effb5414096089375a3a36a3e7af1522ae0"
SRC_URI="
	https://github.com/seanbrant/requests-wsgi-adapter/archive/${COMMIT_HASH}.tar.gz -> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest tests.py
}
