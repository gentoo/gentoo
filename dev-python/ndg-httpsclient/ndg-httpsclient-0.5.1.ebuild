# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="Provides enhanced HTTPS support for httplib and urllib2 using PyOpenSSL"
HOMEPAGE="
	https://github.com/cedadev/ndg_httpsclient/
	https://pypi.org/project/ndg-httpsclient/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-python/pyaes[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]"
# we need to block the previous versions since incorrect namespace
# install breaks tests
BDEPEND="
	test? (
		!!<dev-python/ndg-httpsclient-0.4.2-r1
		dev-libs/openssl:0
	)"

PATCHES=(
	"${FILESDIR}/${P}-expiration-test-fix.patch"
)

distutils_enable_tests unittest

src_test() {
	# we need to start a fake https server for tests to connect to
	( cd ndg/httpsclient/test && sh ./scripts/openssl_https_server.sh ) &
	local server_pid=${!}

	distutils-r1_src_test

	kill "${server_pid}"
	wait
}
