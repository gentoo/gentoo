# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..9} pypy3 )

inherit distutils-r1

DESCRIPTION="A comprehensive HTTP client library"
HOMEPAGE="https://pypi.org/project/httplib2/ https://github.com/jcgregorio/httplib2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND="app-misc/ca-certificates"

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-use-system-cacerts.patch )

src_prepare() {
	sed -i -e '/--cov/d' setup.cfg || die

	# broken by using system certificates
	sed -e 's:test_certs_file_from_builtin:_&:' \
		-e 's:test_certs_file_from_environment:_&:' \
		-e 's:test_with_certifi_removed_from_modules:_&:' \
		-i tests/test_cacerts_from_env.py || die
	# broken by new PySocks, probably
	sed -e 's:test_server_not_found_error_is_raised_for_invalid_hostname:_&:' \
		-e 's:test_socks5_auth:_&:' \
		-i tests/test_proxy.py || die

	distutils-r1_src_prepare
}

python_test() {
	# tests in python* are replaced by tests/
	# upstream fails at cleaning up stuff
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
