# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A Python module for semantic versioning"
HOMEPAGE="
	https://github.com/python-semver/python-semver/
	https://pypi.org/project/semver/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"

distutils_enable_tests pytest

python_test() {
	epytest -o addopts=
}
