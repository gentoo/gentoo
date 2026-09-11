# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A Python Slugify application that handles Unicode"
HOMEPAGE="
	https://github.com/un33k/python-slugify/
	https://pypi.org/project/python-slugify/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/text-unidecode-1.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/anyascii[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
