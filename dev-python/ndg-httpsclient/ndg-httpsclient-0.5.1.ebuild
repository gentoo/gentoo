# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="Provides enhanced HTTPS support for httplib and urllib2 using PyOpenSSL"
HOMEPAGE="
	https://github.com/cedadev/ndg_httpsclient/
	https://pypi.org/project/ndg-httpsclient/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/pyaes[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]"
# we need to block the previous versions since incorrect namespace
# install breaks tests
DEPEND="${RDEPEND}
	test? (
		!!<dev-python/ndg-httpsclient-0.4.2-r1
		dev-libs/openssl:0
		sys-libs/libfaketime
	)"

distutils_enable_tests unittest

src_test() {
	# bundled certificates expired, so we need a time machine
	local -x FAKETIME="@2019-12-01 12:00:00"
	local -x LD_PRELOAD="libfaketime.so:${LD_PRELOAD}"

	# we need to start a fake https server for tests to connect to
	( cd ndg/httpsclient/test && sh ./scripts/openssl_https_server.sh ) &
	local server_pid=${!}

	distutils-r1_src_test

	kill "${server_pid}"
	wait
}
