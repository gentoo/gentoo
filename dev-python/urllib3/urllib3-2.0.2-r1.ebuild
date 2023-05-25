# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_TESTED=( python3_{9..11} pypy3 )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTTP library with thread-safe connection pooling, file post, and more"
HOMEPAGE="
	https://github.com/urllib3/urllib3/
	https://pypi.org/project/urllib3/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="brotli test zstd"
RESTRICT="!test? ( test )"

# [secure] extra is deprecated and slated for removal, we don't need it:
# https://github.com/urllib3/urllib3/issues/2680
RDEPEND="
	>=dev-python/PySocks-1.5.8[${PYTHON_USEDEP}]
	<dev-python/PySocks-2.0[${PYTHON_USEDEP}]
	brotli? ( >=dev-python/brotlicffi-0.8.0[${PYTHON_USEDEP}] )
	zstd? ( >=dev-python/zstandard-0.18.0[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		$(python_gen_cond_dep "
			${RDEPEND}
			dev-python/brotlicffi[\${PYTHON_USEDEP}]
			dev-python/freezegun[\${PYTHON_USEDEP}]
			dev-python/pytest[\${PYTHON_USEDEP}]
			>=dev-python/tornado-4.2.1[\${PYTHON_USEDEP}]
			>=dev-python/trustme-0.5.3[\${PYTHON_USEDEP}]
			>=dev-python/zstandard-0.18.0[\${PYTHON_USEDEP}]
		" "${PYTHON_TESTED[@]}")
	)
"

python_test() {
	local -x CI=1
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=(
		# take forever
		test/contrib/test_pyopenssl.py::TestSocketSSL::test_requesting_large_resources_via_ssl
		test/with_dummyserver/test_socketlevel.py::TestSSL::test_requesting_large_resources_via_ssl
	)

	# plugins make tests slower, and more fragile
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
