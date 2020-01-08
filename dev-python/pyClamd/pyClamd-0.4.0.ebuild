# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="python interface to Clamd (Clamav daemon)"
HOMEPAGE="https://xael.org/pages/pyclamd-en.html"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e 's:/etc/clamav/clamd.conf:/etc/clamd.conf:' \
		-i pyclamd/pyclamd.py || die
}
