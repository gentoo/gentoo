# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Capture C-level stdout/stderr in Python"
HOMEPAGE="
	https://github.com/minrk/wurlitzer/
	https://pypi.org/project/wurlitzer/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv x86"

distutils_enable_tests pytest

python_test() {
	epytest test.py
}
