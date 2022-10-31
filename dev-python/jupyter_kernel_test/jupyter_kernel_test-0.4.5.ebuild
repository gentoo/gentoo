# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Jupyter kernel for octave"
HOMEPAGE="https://github.com/jupyter/jupyter_kernel_test"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/jupyter_client-6.1.13[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/ipykernel[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
