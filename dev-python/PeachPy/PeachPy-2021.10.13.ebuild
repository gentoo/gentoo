# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

CommitId=257881e0a7ce985c1cf96653db1264bf09adf510

DESCRIPTION="Portable Efficient Assembly Code-generator in Higher-level Python"
HOMEPAGE="https://pypi.org/project/PeachPy/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # depends on an old version of werkzeug

RDEPEND="
	dev-python/Opcodes[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"/${PN}-${CommitId}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )
