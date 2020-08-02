# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

DESCRIPTION="Python interface to thetvdb.com API"
HOMEPAGE="https://github.com/dbr/tvdb_api"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/requests-cache[${PYTHON_USEDEP}]"
