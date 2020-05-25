# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/urllib3/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="brotli test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.3.4[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.14[${PYTHON_USEDEP}]
	>=dev-python/idna-2.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/ipaddress[${PYTHON_USEDEP}]
	' -2)
	brotli? ( dev-python/brotlipy[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlipy[\${PYTHON_USEDEP}]
			dev-python/mock[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=www-servers/tornado-4.2.1[\${PYTHON_USEDEP}]
		" python3_{6,7,8})
	)
"

distutils_enable_sphinx docs \
	dev-python/alabaster \
	dev-python/mock

python_prepare_all() {
	# https://github.com/urllib3/urllib3/issues/1756
	sed -e 's:10.255.255.1:240.0.0.0:' \
		-i test/__init__.py || die
	# tests failing if 'localhost.' cannot be resolved
	sed -e 's:test_dotted_fqdn:_&:' \
		-i test/with_dummyserver/test_https.py || die
	sed -e 's:test_request_host_header_ignores_fqdn_dot:_&:' \
		-i test/with_dummyserver/test_socketlevel.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x CI=1
	# FIXME: get tornado ported
	case ${EPYTHON} in
		python2*)
			ewarn "Tests are being skipped for Python 2 in order to reduce the number"
			ewarn "of circular dependencies for Python 2 removal.  Please test"
			ewarn "manually in a virtualenv."
			;;
		python3.9)
			einfo "Tests not yet ported to py3.9"
			;;
		python3*)
			pytest -vv || die "Tests fail with ${EPYTHON}"
			;;
	esac
}
