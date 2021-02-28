# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Django App that adds CORS (Cross-Origin Resource Sharing) headers to responses"
HOMEPAGE="https://github.com/adamchainz/django-cors-headers"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Tests need a configured database
RESTRICT="test"

RDEPEND=">=dev-python/django-1.11[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
