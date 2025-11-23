# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Finds the correct path to exceptions in the requests library"
HOMEPAGE="
	https://opendev.org/openstack/requestsexceptions/
	https://github.com/openstack/requestsexceptions/
	https://pypi.org/project/requestsexceptions/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
"
