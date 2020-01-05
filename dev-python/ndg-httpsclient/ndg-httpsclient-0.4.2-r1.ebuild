# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

DESCRIPTION="Provides enhanced HTTPS support for httplib and urllib2 using PyOpenSSL"
HOMEPAGE="
	https://github.com/cedadev/ndg_httpsclient/
	https://pypi.org/project/ndg-httpsclient/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyopenssl[$(python_gen_usedep 'python*' pypy)]"
# we need to block the previous versions since incorrect namespace
# install breaks tests
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		!!<dev-python/ndg-httpsclient-0.4.2-r1
		dev-libs/openssl:0
	)"

S="${WORKDIR}/${P/-/_}"

# doc build by Makefile in folder documentation is broken

src_test() {
	# we need to start a fake https server for tests to connect to
	( cd ndg/httpsclient/test && sh ./scripts/openssl_https_server.sh ) &
	local server_pid=${!}

	distutils-r1_src_test

	kill "${server_pid}"
	wait
}

python_test() {
	"${PYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# install the namespace (this is the only package in ::gentoo
	# using it; we'll split it if we add more)
	python_moduleinto ndg
	python_domodule ndg/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
