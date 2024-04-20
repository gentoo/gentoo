# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="JavaScript minifier"
HOMEPAGE="
	https://pypi.org/project/jsmin/
	https://github.com/tikitu/jsmin/
"

KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
LICENSE="MIT"
SLOT="0"

distutils_enable_tests unittest
