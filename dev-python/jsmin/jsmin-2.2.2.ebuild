# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="JavaScript minifier"
HOMEPAGE="https://pypi.org/project/jsmin/ https://github.com/tikitu/jsmin/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="MIT"
SLOT="0"

python_test() {
	"${EPYTHON}" -m jsmin.test -v || die "Tests failed with ${EPYTHON}"
}
