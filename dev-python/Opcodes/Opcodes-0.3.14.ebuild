# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

CommitId=0f7c7d63f5e13ce5a89d9acc3934f1b6e247ec1f

DESCRIPTION="Opcodes Project"
HOMEPAGE="
	https://pypi.org/project/Opcodes/
"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test" # depends on an old version of werkzeug

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND=""

S="${WORKDIR}"/${PN}-${CommitId}
