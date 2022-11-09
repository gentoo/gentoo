# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Metakernel for Jupyter"
HOMEPAGE="https://github.com/Calysto/metakernel"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/ipykernel-5.5.6[${PYTHON_USEDEP}]
	>=dev-python/jupyter_core-4.9.2[${PYTHON_USEDEP}]
	>=dev-python/jedi-0.18[${PYTHON_USEDEP}]
	>=dev-python/pexpect-4.8[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/jupyter_kernel_test[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.25.0-disable-brittle-tests.patch
)

distutils_enable_tests pytest
