# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python filtering architecture for the Courier MTA"
HOMEPAGE="https://bitbucket.org/gordonmessmer/courier-pythonfilter/src/default/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="mail-mta/courier"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
