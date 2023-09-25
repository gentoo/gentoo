# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="The logutils package provides a set of handlers for the Python standard"
HOMEPAGE="https://bitbucket.org/vinay.sajip/logutils"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv x86"

BDEPEND="
	test? (
		dev-db/redis
		dev-python/redis[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
