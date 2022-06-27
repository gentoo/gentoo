# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="
	https://github.com/urllib3/urllib3/
	https://pypi.org/project/urllib3/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="brotli test"
RESTRICT="!test? ( test )"

# dev-python/{pyopenssl,cryptography,idna,certifi} are optional runtime
# dependencies. Do not add them to RDEPEND. They should be unnecessary with
# modern versions of python (>= 3.2).
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
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
		" python3_{8..11})
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# unbundle urllib3
	rm src/urllib3/packages/six.py || die
	find -name '*.py' -exec sed -i \
		-e 's:\([.]*\|urllib3\.\)\?packages\.six:six:g' \
		-e 's:from \([.]*\|urllib3\.\)\?packages import six:import six:g' \
		{} + || die
}

python_test() {
	local -x CI=1
	# FIXME: get tornado ported
	# please keep in sync with BDEPEND!
	if ! has "${EPYTHON}" python3.{8..11}; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# unstable (relies on warning count)
		test/with_dummyserver/test_proxy_poolmanager.py::TestHTTPProxyManager::test_proxy_verified_warning
	)
	has "${EPYTHON}" python3.{8..10} && EPYTEST_DESELECT+=(
		test/contrib/test_pyopenssl.py::TestPyOpenSSLHelpers::test_get_subj_alt_name
	)

	epytest
}
