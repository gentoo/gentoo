# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{9,10} )

inherit distutils-r1

DESCRIPTION="Utility for fetching patchsets from public-inbox"
HOMEPAGE="https://pypi.org/project/b4/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/dkimpy[${PYTHON_USEDEP}]
	dev-python/patatt[${PYTHON_USEDEP}]
"
