# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Small, dependency-free, fast Python package to infer binary file types checking"
HOMEPAGE="
	https://github.com/h2non/filetype.py/
	https://pypi.org/project/filetype/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

distutils_enable_tests unittest
