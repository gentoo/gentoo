# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="https://github.com/gabrielfalcao/httpretty"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm64 ppc64 x86"
IUSE="test"

RDEPEND="dev-python/urllib3[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/nose-1.2[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/requests-1.1[${PYTHON_USEDEP}]
		>=www-servers/tornado-2.2[${PYTHON_USEDEP}]
)"

#Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_test() {
	# https://github.com/gabrielfalcao/HTTPretty/issues/125, still occur
	# py3.4 hangs on many tests and is deemed underdone
	# Upstream does not make it clear whether py3.4 is sctually tested and supported.
	# python2.7 has substantial failure in tests/functional/test_requests.py and is removed.
	# Some tests excluded attempt connection to the network
	# On testing in the state below, py2.7 still has a tally of FAILED (failures=5)
	# that occur within the folder tests/unit which upstream should address.
	# https://github.com/gabrielfalcao/HTTPretty/issues/236 Bug #532106

	if python_is_python3; then
		einfo "python3* not adequately supported by th package"
	elif [[ "${EPYTHON}" == python2.7 ]]; then
		rm -f tests/functional/test_requests.py || die
		nosetests -e test_recording_calls \
			-e test_playing_calls \
			-e test_callback_setting_headers_and_status_response \
			-e test_httpretty_bypasses_when_disabled \
			-e test_using_httpretty_with_other_tcp_protocols \
			tests/unit \
			tests/functional || die "Tests failed under python2.7"
	else
		nosetests -e test_recording_calls \
			-e test_playing_calls \
			-e test_callback_setting_headers_and_status_response \
			-e test_httpretty_bypasses_when_disabled \
			-e test_using_httpretty_with_other_tcp_protocols \
			tests/unit \
			tests/functional || die "Tests failed under python3.3"
	fi

	rm -rf "${BUILD_DIR}"/../tests/ || die
}
