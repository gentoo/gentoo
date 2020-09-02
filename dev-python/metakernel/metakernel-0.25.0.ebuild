# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/pexpect[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-0.25.0-disable-brittle-tests.patch )
