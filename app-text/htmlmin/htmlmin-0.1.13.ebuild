# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1

DESCRIPTION="A configurable HTML Minifier with safety features (htmlmin2 fork)"
HOMEPAGE="
	https://github.com/wilhelmer/htmlmin/
	https://pypi.org/project/htmlmin2/
"
SRC_URI="
	https://github.com/wilhelmer/htmlmin/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

distutils_enable_tests unittest
