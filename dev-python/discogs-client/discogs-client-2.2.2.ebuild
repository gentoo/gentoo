# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Official Python API client for Discogs"
HOMEPAGE="https://github.com/discogs/discogs_client https://pypi.org/project/discogs-client/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	"

distutils_enable_tests unittest
