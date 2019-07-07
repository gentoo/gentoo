# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Python interface to sendmail milter API"
HOMEPAGE="https://github.com/sdgathman/pymilter"
SRC_URI="https://github.com/sdgathman/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="mail-filter/libmilter"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${P}"

python_test() {
	"${EPYTHON}" -m unittest discover -v || die
}
