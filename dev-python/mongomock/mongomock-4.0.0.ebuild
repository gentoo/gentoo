# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Library to help testing Python code that interacts with MongoDB via Pymongo"
HOMEPAGE="https://github.com/mongomock/mongomock https://pypi.org/project/mongomock/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

BDEPEND=">=dev-python/pbr-5.1.1[${PYTHON_USEDEP}]"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/pymongo-3.10.1[${PYTHON_USEDEP}]
	>=dev-python/sentinels-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.14.0[${PYTHON_USEDEP}]"

src_test() {
	# Use NO_LOCAL_MONGO to disable tests that need a MongoDB instance.
	# TZ=UTC needed for date/time tests to pass
	TZ=UTC NO_LOCAL_MONGO=1 distutils-r1_src_test
}

distutils_enable_tests pytest
