# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A simple serialization library based on ast.literal_eval"
HOMEPAGE="
	https://github.com/irmen/Serpent/
	https://pypi.org/project/serpent/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"

BDEPEND="
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
