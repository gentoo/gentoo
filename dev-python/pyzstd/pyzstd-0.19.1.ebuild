# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/Rogdham/pyzstd
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Support for Zstandard (zstd) compression"
HOMEPAGE="
	https://github.com/Rogdham/pyzstd/
	https://pypi.org/project/pyzstd/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/backports-zstd-1.0.0[${PYTHON_USEDEP}]
	' 3.11 3.12 3.13)
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' 3.11 3.12)
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
