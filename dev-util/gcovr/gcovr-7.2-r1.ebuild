# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit toolchain-funcs distutils-r1

DESCRIPTION="A Python script for summarizing gcov data"
HOMEPAGE="https://github.com/gcovr/gcovr"
SRC_URI="https://github.com/gcovr/gcovr/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/yaxmldiff[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x PATH="${TEST_DIR}/scripts:${PATH}" \
		PYTHONPATH="${TEST_DIR}/lib"

	# these tests assume gcc-8, and fail with newer gcc versions
	local -a test_build_deselect=(
		"add_coverages-coveralls"
		"add_coverages-html"
		"add_coverages-html"
		"bad++char-coveralls"
		"bad++char-html"
		"calls-html"
		"cmake_oos-coveralls"
		"cmake_oos-html"
		"cmake_oos_ninja-coveralls"
		"cmake_oos_ninja-html"
		"coexisting_object_directories-from_build_dir-cobertura"
		"coexisting_object_directories-from_build_dir-html"
		"coexisting_object_directories-from_build_dir-without_object_dir-cobertura"
		"coexisting_object_directories-from_build_dir-without_object_dir-html"
		"coexisting_object_directories-from_build_dir-without_object_dir-sonarqube"
		"coexisting_object_directories-from_build_dir-without_object_dir-txt"
		"coexisting_object_directories-from_build_dir-without_search_dir-cobertura"
		"coexisting_object_directories-from_build_dir-without_search_dir-html"
		"coexisting_object_directories-from_build_dir-without_search_dir-sonarqube"
		"coexisting_object_directories-from_build_dir-without_search_dir-txt"
		"coexisting_object_directories-from_root_dir-cobertura"
		"coexisting_object_directories-from_root_dir-html"
		"coexisting_object_directories-from_root_dir-without_object_dir-cobertura"
		"coexisting_object_directories-from_root_dir-without_object_dir-html"
		"coexisting_object_directories-from_root_dir-without_object_dir-sonarqube"
		"coexisting_object_directories-from_root_dir-without_object_dir-txt"
		"coexisting_object_directories-from_root_dir-without_search_dir-cobertura"
		"coexisting_object_directories-from_root_dir-without_search_dir-html"
		"coexisting_object_directories-from_root_dir-without_search_dir-sonarqube"
		"coexisting_object_directories-from_root_dir-without_search_dir-txt"
		"config-output-html"
		"config-toml-html"
		"config-toml-txt"
		"decisions-html"
		"decisions-json"
		"decisions-neg-delta-html"
		"different-function-lines-separate-coveralls"
		"different-function-lines-separate-html"
		"different-function-lines-use-0-coveralls"
		"different-function-lines-use-0-html"
		"different-function-lines-use-max-coveralls"
		"different-function-lines-use-max-html"
		"different-function-lines-use-min-coveralls"
		"different-function-lines-use-min-html"
		"dot-coveralls"
		"dot-html"
		"excl-branch-coveralls"
		"excl-branch-html"
		"excl-line-branch-coveralls"
		"excl-line-branch-html"
		"excl-line-coveralls"
		"excl-line-custom-coveralls"
		"excl-line-custom-html"
		"excl-line-html"
		"exclude-directories-relative-coveralls"
		"exclude-directories-relative-html"
		"exclude-lines-by-pattern-coveralls"
		"exclude-lines-by-pattern-html"
		"exclude-relative-coveralls"
		"exclude-relative-from-unfiltered-tracefile-html"
		"exclude-relative-html"
		"exclude-throw-branches-cobertura"
		"exclude-throw-branches-coveralls"
		"exclude-throw-branches-html"
		"exclude-throw-branches-jacoco"
		"exclude-throw-branches-json"
		"exclude-throw-branches-lcov"
		"exclude-throw-branches-sonarqube"
		"exclude-throw-branches-txt"
		"filter-absolute-coveralls"
		"filter-absolute-from-unfiltered-tracefile-html"
		"filter-absolute-html"
		"filter-relative-coveralls"
		"filter-relative-from-unfiltered-tracefile-html"
		"filter-relative-html"
		"filter-relative-lib-coveralls"
		"filter-relative-lib-from-unfiltered-tracefile-html"
		"filter-relative-lib-html"
		"html-css-html"
		"html-default-html"
		"html-encoding-cp1252-html"
		"html-encoding-iso-8859-15-html"
		"html-high-100-html"
		"html-high-75-html"
		"html-line-branch-html"
		"html-medium-100-high-100-html"
		"html-medium-50-html"
		"html-nested-filter-html"
		"html-nested-nonsort-html"
		"html-nested-sort-casefold-html"
		"html-nested-sort-percentage-html"
		"html-nested-sort-uncovered-html"
		"html-source-encoding-cp1252-html"
		"html-source-encoding-utf8-html"
		"html-tab-size-2-html"
		"html-template-dir-html"
		"html-themes-github-html"
		"html-themes-html"
		"html-title-html"
		"linked-coveralls"
		"linked-html"
		"nested-coveralls"
		"nested-html"
		"nested2-coveralls"
		"nested2-coveralls"
		"nested2-html"
		"nested2-html"
		"nested2-use-existing-coveralls"
		"nested2-use-existing-html"
		"nested3-coveralls"
		"no-markers-html"
		"nobranch-coveralls"
		"nobranch-html"
		"noncode-coveralls"
		"noncode-html"
		"oos-coveralls"
		"oos-html"
		"oos2-coveralls"
		"oos2-html"
		"rounding-html"
		"shadow-coveralls"
		"shadow-html"
		"shared_lib-coveralls"
		"shared_lib-html"
		"simple1-coveralls"
		"simple1-dir-coveralls"
		"simple1-dir-html"
		"simple1-html"
		"simple1-stdout-coveralls"
		"simple1-stdout-html"
		"sort-percentage-html"
		"sort-uncovered-html"
		"source_from_pipe-cobertura"
		"source_from_pipe-coveralls"
		"source_from_pipe-html"
		"source_from_pipe-lcov"
		"subfolder-includes-html"
		"threaded-coveralls"
		"threaded-html"
		"update-data-coveralls"
		"update-data-html"
		"use-existing-coveralls"
		"use-existing-html"
		"wspace-coveralls"
		"wspace-html"
	)

	local cc cc_ver
	cc="$(tc-get-compiler-type)"
	case "${cc}" in
		gcc)
			cc_ver="$(gcc-major-version)"

			# a bunch of tests are broken on gcc-14
			# https://bugs.gentoo.org/930680
			if [[ $(gcc-major-version) -ge 14 ]]; then
				test_build_deselect+=(
					"calls-json"
					"decisions-neg-delta-json"
					"different-function-lines-separate-lcov"
					"different-function-lines-use-0-lcov"
					"different-function-lines-use-max-lcov"
					"different-function-lines-use-min-lcov"
					"dot-lcov"
					"excl-branch-lcov"
					"excl-line-json"
					"excl-line-lcov"
					"excl-line-branch-lcov"
					"excl-line-custom-lcov"
					"exclude-directories-relative-lcov"
					"exclude-lines-by-pattern-lcov"
					"exclude-relative-lcov"
					"exclude-relative-from-unfiltered-tracefile-lcov"
					"filter-absolute-lcov"
					"filter-absolute-from-unfiltered-tracefile-lcov"
					"filter-relative-lcov"
					"filter-relative-from-unfiltered-tracefile-lcov"
					"filter-relative-lib-lcov"
					"filter-relative-lib-from-unfiltered-tracefile-lcov"
					"linked-lcov"
					"nested-lcov"
					"nested2-lcov"
					"nested3-lcov"
					"no-markers-json"
					"no-markers-lcov"
					"noncode-json"
					"noncode-lcov"
					"oos-lcov"
					"oos2-lcov"
					"shadow-json"
					"simple1-txt"
					"simple1-json"
					"simple1-dir-json"
					"simple1-stdout-json"
					"simple1-stdout-lcov"
					"threaded-lcov"
					"update-data-lcov"
					"wspace-lcov"
				)
			fi
		;;
		clang) cc_ver="$(clang-major-version)";;
		# placeholder since tests need CC_REFERENCE to be string-number
		*) cc_ver=1;;
	esac

	readarray -t EPYTEST_DESELECT < <(printf 'gcovr/tests/test_gcovr.py::test_build[%s]\n' "${test_build_deselect[@]}")

	EPYTEST_DESELECT+=(
		# tests that don't work in the ebuild environment
		gcovr/tests/test_args.py::test_html_template_dir
		gcovr/tests/test_args.py::test_multiple_output_formats_to_stdout
		gcovr/tests/test_args.py::test_multiple_output_formats_to_stdout_1
	)
	local -x CC_REFERENCE="${cc}-${cc_ver}"

	epytest gcovr
}
