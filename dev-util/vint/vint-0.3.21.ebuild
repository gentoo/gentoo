# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Lint tool for Vim script language"
HOMEPAGE="https://github.com/Kuniwak/vint https://pypi.org/project/vim-vint/"
SRC_URI="https://github.com/Kuniwak/vint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/ansicolor-0.2.4[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.8.patch"
)

distutils_enable_tests pytest
