# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A CSS Cascading Style Sheets library (fork of cssutils)"
HOMEPAGE="
	https://github.com/ebook-utils/css-parser/
	https://pypi.org/project/css-parser/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-python/chardet[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
