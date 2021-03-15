# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="https://github.com/urllib3/urllib3"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv s390 sparc x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="brotli test"
RESTRICT="!test? ( test )"

# dev-python/{pyopenssl,cryptography,idna,certifi} are optional runtime
# dependencies. Do not add them to RDEPEND. They should be unnecessary with
# modern versions of python (>= 3.2).
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	brotli? ( dev-python/brotlicffi[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlicffi[\${PYTHON_USEDEP}]
			dev-python/mock[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			dev-python/pytest-freezegun[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=www-servers/tornado-4.2.1[\${PYTHON_USEDEP}]
		" python3_{6,7,8,9})
	)
"

python_prepare_all() {
	# https://github.com/urllib3/urllib3/issues/1756
	sed -e 's:10.255.255.1:240.0.0.0:' \
		-i test/__init__.py || die
	# upstream requires updates to this periodically.  seriously?!
	sed -e '/RECENT_DATE/s:date(.*):date(2020, 7, 1):' \
		-i src/urllib3/connection.py || die
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
	[[ ${EPYTHON} == python3* ]] || continue

	local deselect=(
		# TODO?
		test/with_dummyserver/test_socketlevel.py::TestSocketClosing::test_timeout_errors_cause_retries
	)

	pytest -vv ${deselect[@]/#/--deselect } ||
		die "Tests fail with ${EPYTHON}"
}
