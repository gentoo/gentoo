# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Finds the correct path to exceptions in the requests library"
HOMEPAGE="https://github.com/openstack-infra/requestsexceptions"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"
