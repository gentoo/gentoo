# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8})

DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="https://github.com/tardyp/txrequests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/requests-1.2.0[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
