# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
# py3.12, py3.15 crashes...
PYTHON_COMPAT=( python3_{13..14} )

inherit distutils-r1

DESCRIPTION="Simple assertion library for unit testing in python with a fluent API"
HOMEPAGE="
	https://github.com/assertpy/assertpy/
	https://pypi.org/project/assertpy/
"
# no tests in sdist
SRC_URI="
	https://github.com/assertpy/assertpy/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/jsonpath-ng[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGIN_LOAD_VIA_ENV=1
EPYTEST_PLUGINS=( "${PN}" hypothesis pytest-{cov,xdist} )
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# tries to install stuff via pip (online)
		tests/test_typing_from_a_wheel.py
		# require ruff python module
		tests/test_check_protocols.py::test_the_generated_twins_match_the_protocols_they_mirror
		tests/test_complexity.py::test_no_function_grew_more_complex
		tests/test_complexity.py::test_the_record_is_not_stale
		tests/test_poll_protocols.py::test_the_generated_twins_match_the_views_they_mirror
		tests/test_poll_protocols.py::test_the_generated_verdict_twin_matches_the_views_it_mirrors
		tests/test_capable_protocol.py::test_the_facade_matches_what_the_generator_produces
		tests/test_negated_protocols.py::test_the_file_is_what_the_generator_writes
		# broken by explicit plugin loading
		tests/test_dangling.py::TestUnderARealPytestRun
		tests/test_dangling.py::TestEveryFindingReachesExactlyOneTest
		# TODO
		tests/test_structural.py::TestExactnessReachesDataclassesAndTypedDicts::test_a_tag_an_extra_was_put_over_tells_no_typed_dict_apart
		# TODO: weird shutil.rmtree() errors over teardown
		tests/test_snapshots.py::TestALockFileBeingDeleted
		# stack limit
		tests/test_structural.py::TestExactnessRefusesWhatItCannotPair::test_a_nesting_deeper_than_the_walk_follows_is_refused
	)

	local -x PYTHONPATH=${PWD}
	epytest -o tmp_path_retention_count=1
}
