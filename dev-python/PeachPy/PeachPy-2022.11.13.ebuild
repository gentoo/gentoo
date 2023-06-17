# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

CommitId=349e8f836142b2ed0efeb6bb99b1b715d87202e9

DESCRIPTION="Portable Efficient Assembly Code-generator in Higher-level Python"
HOMEPAGE="https://pypi.org/project/PeachPy/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.gh.tar.gz"

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
