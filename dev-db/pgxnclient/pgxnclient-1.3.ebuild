# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="PostgreSQL Extension Network Client"
HOMEPAGE="http://pgxnclient.projects.postgresql.org/ https://pypi.org/project/pgxnclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

LICENSE="BSD"
SLOT="0"

IUSE="test"

# Test data isn't included in releases. So, the tests fail.
# https://github.com/pgxn/pgxnclient/issues/36
RESTRICT="test
	!test? ( test )"

distutils_enable_tests pytest

RDEPEND="dev-db/postgresql:*[server]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND+="${RDEPEND}
	test? (	dev-python/mock[${PYTHON_USEDEP}] )
"

src_prepare() {
	sed "s/find_packages()/find_packages(exclude=['tests'])/" -i setup.py || die

	default
}
