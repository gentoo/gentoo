# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Common code for Synapse, Sydent and Sygnal"
HOMEPAGE="
	https://github.com/matrix-org/matrix-python-common
	https://pypi.org/project/matrix-common/
"
SRC_URI="
	https://github.com/matrix-org/matrix-python-common/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/matrix-python-common-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
