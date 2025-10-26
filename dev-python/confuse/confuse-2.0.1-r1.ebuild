# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A configuration library for Python that uses YAML"
HOMEPAGE="
	https://github.com/beetbox/confuse/
	https://pypi.org/project/confuse/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
distutils_enable_sphinx docs \
	'dev-python/sphinx-rtd-theme'

PATCHES=(
	# https://github.com/beetbox/confuse/commit/ed79b4b9f53fe99293139c18f053168e564508b8
	"${FILESDIR}/${P}-py314.patch"
)
