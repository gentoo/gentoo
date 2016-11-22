# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="tzinfo object for the local timezone"
HOMEPAGE="https://github.com/regebro/tzlocal"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDPEND="dev-python/pytz[${PYTHON_USEDEP}]"

python_test() {
	unset TZ
	"${PYTHON}" -m unittest discover || die "Testing failed with ${EPYTHON}"
}
