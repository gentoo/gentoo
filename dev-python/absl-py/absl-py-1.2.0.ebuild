# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=abseil-py-${PV}
DESCRIPTION="Abseil Python Common Libraries"
HOMEPAGE="
	https://github.com/abseil/abseil-py/
	https://pypi.org/project/absl-py/
"
SRC_URI="
	https://github.com/abseil/abseil-py/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	# what a nightmare... well, we could have called bazel but that would
	# even worse
	local helpers=(
		absl/flags/tests/argparse_flags_test_helper.py:absl/flags/tests/argparse_flags_test_helper
		absl/logging/tests/logging_functional_test_helper.py:absl/logging/tests/logging_functional_test_helper
		absl/testing/tests/absltest_fail_fast_test_helper.py:absl/testing/tests/absltest_fail_fast_test_helper
		absl/testing/tests/absltest_filtering_test_helper.py:absl/testing/tests/absltest_filtering_test_helper
		absl/testing/tests/absltest_randomization_testcase.py:absl/testing/tests/absltest_randomization_testcase
		absl/testing/tests/absltest_sharding_test_helper.py:absl/testing/tests/absltest_sharding_test_helper
		absl/testing/tests/absltest_test_helper.py:absl/testing/tests/absltest_test_helper
		absl/testing/tests/xml_reporter_helper_test.py:absl/testing/tests/xml_reporter_helper_test
		absl/tests/app_test_helper.py:absl/tests/app_test_helper_pure_python
	)

	local x
	for x in "${helpers[@]}"; do
		local script=${x%:*}
		local sym=${x#*:}
		sed -i -e "1i#!/usr/bin/env python" "${script}" || die
		chmod +x "${script}" || die
		ln -s "${script##*/}" "${sym}" || die
	done

	# i don't wanna know how these pass for upstream with wrong helper names
	sed -i -e 's:\(app_test_helper\)\.py:\1_pure_python:' \
		absl/tests/app_test.py || die
	sed -i -e 's:\(logging_functional_test_helper\)\.py:\1:' \
		absl/logging/tests/logging_functional_test.py || die

	distutils-r1_src_prepare
}

python_test() {
	local -x PYTHONPATH=.
	local fails=0
	while read -r -d '' x; do
		ebegin "${x}"
		"${EPYTHON}" "${x}"
		eend ${?} || : "$(( fails += 1 ))"
	done < <(find -name '*_test.py' -print0)

	[[ ${fails} -ne 0 ]] && die "${fails} tests failed on ${EPYTHON}"

	# we actually need to clean this up manually before running the test
	# suite again...
	chmod -R u+rwX "${T}"/absl_testing || die
	rm -rf "${T}"/absl_testing || die
}
