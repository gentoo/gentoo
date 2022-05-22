# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="python-requests HTTP exchanges recorder"
HOMEPAGE="
	https://github.com/betamaxpy/betamax/
	https://pypi.org/project/betamax/
"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-pytest.patch"
)

EPYTEST_DESELECT=(
	# Internet
	tests/integration/test_hooks.py
	tests/integration/test_placeholders.py
	tests/integration/test_record_modes.py::TestRecordOnce::test_records_new_interaction
	tests/integration/test_record_modes.py::TestRecordOnce::test_replays_response_from_cassette
	tests/integration/test_record_modes.py::TestRecordNewEpisodes
	tests/integration/test_record_modes.py::TestRecordNewEpisodesCreatesCassettes
	tests/integration/test_record_modes.py::TestRecordAll
	tests/integration/test_unicode.py
	tests/regression/test_gzip_compression.py
	tests/regression/test_requests_2_11_body_matcher.py
)
