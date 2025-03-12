# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Stand alone tool to interact with KernelCI"
HOMEPAGE="
	https://github.com/kernelci/kci-dev
	https://pypi.org/project/kci-dev/
"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/gitpython-3.1.43[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' 3.10)
"
