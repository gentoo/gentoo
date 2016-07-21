# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy pypy3 )

inherit distutils-r1

MY_PN="redis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for Redis key-value store"
HOMEPAGE="https://github.com/andymccurdy/redis-py"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-db/redis
		>=dev-python/pytest-2.5.0[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-test-finalize.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Make sure that tests will be used from BUILD_DIR rather than cwd.
	mv tests tests-hidden || die

	# Correct local import patch syntax
	sed -e 's:from .conftest:from conftest:' \
		-i tests-hidden/{test_connection_pool.py,test_commands.py,test_encoding.py,test_pubsub.py} \
		|| die
}

python_compile() {
	distutils-r1_python_compile

	if use test; then
		cp -r tests-hidden "${BUILD_DIR}"/tests || die
	fi
}

python_test() {
	local sock="${T}/redis.sock"

	"${EPREFIX}/usr/sbin/redis-server" - <<- EOF
		daemonize yes
		pidfile "${T}/redis.pid"
		unixsocket ${sock}
		EOF

	PYTHONPATH="${S}:${S}/tests-hidden"
	esetup.py test --verbose
	kill $(<"${T}/redis.pid")
}
