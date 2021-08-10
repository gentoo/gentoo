# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS="no"
inherit distutils-r1

DESCRIPTION="Braintree Python Library"
HOMEPAGE="https://developers.braintreepayments.com/python/sdk/server/overview"
SRC_URI="mirror://pypi/b/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/requests-0.11.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

DOCS=(README.md)
