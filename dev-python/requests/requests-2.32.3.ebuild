# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 pypi

DESCRIPTION="HTTP library for human beings"
HOMEPAGE="
	https://requests.readthedocs.io/
	https://github.com/psf/requests/
	https://pypi.org/project/requests/
"

SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-2.32.3-patches.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"
IUSE="socks5 test-rust"

RDEPEND="
	>=dev-python/certifi-2017.4.17[${PYTHON_USEDEP}]
	<dev-python/charset-normalizer-4[${PYTHON_USEDEP}]
	<dev-python/idna-4[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
	socks5? ( >=dev-python/pysocks-1.5.6[${PYTHON_USEDEP}] )
"

BDEPEND="
	test? (
		>=dev-python/pytest-httpbin-2.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		>=dev-python/pysocks-1.5.6[${PYTHON_USEDEP}]
		test-rust? (
			dev-python/trustme[${PYTHON_USEDEP}]
		)
	)
"

PATCHES=(
	# https://github.com/psf/requests/pull/6897
	"${WORKDIR}/${PN}-2.32.3-patches/${PN}-2.32.3-tests.patch"
	"${WORKDIR}/${PN}-2.32.3-patches/${PN}-2.32.3-tests-regenerate.patch"
	# https://github.com/psf/requests/pull/6924
	"${WORKDIR}/${PN}-2.32.3-patches/${PN}-2.32.3-tests-more.patch"
)

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Internet (doctests)
		requests/__init__.py::requests
		requests/api.py::requests.api.request
		requests/models.py::requests.models.PreparedRequest
		requests/sessions.py::requests.sessions.Session
		# require IPv4 interface in 10.* range
		tests/test_requests.py::TestTimeout::test_connect_timeout
		tests/test_requests.py::TestTimeout::test_total_timeout_connect
		# As of 2.32.3, with python-3.13.3, despite the patches we've
		# backported, this still seems to fail. Maybe openssl-3.5?
		tests/test_requests.py::TestPreparingURLs::test_different_connection_pool_for_tls_settings_verify_bundle_unexpired_cert
	)

	case ${EPYTHON} in
		python3.13)
			;&
		python3.12)
			EPYTEST_DESELECT+=(
				# different repr()
				requests/utils.py::requests.utils.from_key_val_list
			)
			;;
	esac

	if ! has_version "dev-python/trustme[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_requests.py::TestRequests::test_https_warnings
		)
	fi

	epytest
}
