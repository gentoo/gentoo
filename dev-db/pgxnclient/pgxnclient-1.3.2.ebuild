# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 pypi

DESCRIPTION="PostgreSQL Extension Network Client"
HOMEPAGE="https://pgxn.github.io/pgxnclient/
	https://pypi.org/project/pgxnclient/"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

LICENSE="BSD"
SLOT="0"

IUSE="test"

RDEPEND="dev-db/postgresql:*[server]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/mock )
"

# Test data is currently missing from the distribution. Next release
# will include it.
RESTRICT="test"
distutils_enable_tests pytest

src_prepare() {
	sed "s/setup_requires/#/" -i setup.py || die
	sed "s/find_packages()/find_packages(exclude=['tests'])/" -i setup.py || die

	default
}
