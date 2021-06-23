# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Finds the correct path to exceptions in the requests library."
HOMEPAGE="https://github.com/openstack-infra/requestsexceptions"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

DEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]"
