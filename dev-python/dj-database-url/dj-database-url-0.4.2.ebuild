# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Use Database URLs in your Django Application"
HOMEPAGE="
	https://pypi.org/project/dj-database-url/
	https://github.com/kennethreitz/dj-database-url"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

# Not contained in the tarball
RESTRICT=test

python_test() {
	"${PYTHON}" test_dj_database_url.py || die
}
