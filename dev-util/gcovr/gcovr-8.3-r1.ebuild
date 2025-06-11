# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit toolchain-funcs distutils-r1

DESCRIPTION="Python script for summarizing gcov data"
HOMEPAGE="https://github.com/gcovr/gcovr"
SRC_URI="https://github.com/gcovr/gcovr/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"

RDEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.13.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	' 3.10)
"
BDEPEND="
	dev-python/hatch-fancy-pypi-readme[${PYTHON_USEDEP}]
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/yaxmldiff[${PYTHON_USEDEP}]
	)
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

distutils_enable_tests pytest

python_test() {
	local -a test_build_deselect=(
		# These tests assume gcc-8, and fail with newer gcc versions
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

		# Differences in HTML or just hash changes
		"coexisting_object_directories-from_build_dir-without_search_dir-coveralls"
		"different-conditions-fold-html"
		"different-conditions-fold-coveralls"
		"excl-function-html"
		"excl-function-json"
		"excl-function-coveralls"
		"excl-source-branch-html"
		"excl-source-branch-json"
		"excl-source-branch-coveralls"
		"html-single-page-html"
		"include-html"
		"include-json"
		"include-coveralls"
		"inline-function-html"
		"less-lines-html"
		"nested2-use-existing-txt"
		"nested2-use-existing-cobertura"
		"nested2-use-existing-jacoco"
		"nested2-use-existing-lcov"
		"nested2-use-existing-sonarqube"
		"update-data-json"

		# Needs bazel
		"bazel-json"

		# Fail outside of a git repo
		"coexisting_object_directories-from_build_dir-coveralls"
		"coexisting_object_directories-from_build_dir-without_object_dir-coveralls"
		"coexisting_object_directories-from_root_dir-coveralls"
		"coexisting_object_directories-from_root_dir-without_object_dir-coveralls"
		"coexisting_object_directories-from_root_dir-without_search_dir-coveralls"
		"simple1-dir-txt"
		"simple1-dir-json"
		"simple1-dir-json_summary"
		"simple1-dir-csv"
		"simple1-dir-cobertura"
		"simple1-dir-jacoco"
		"simple1-dir-sonarqube"
		"wspace-txt"
		"wspace-cobertura"
		"wspace-jacoco"
		"wspace-lcov"
		"wspace-sonarqube"
	)

	local cc cc_ver
	cc="$(tc-get-compiler-type)"
	case "${cc}" in
		gcc)
			cc_ver="$(gcc-major-version)"

			# A bunch of tests are broken on gcc-15 (bug #930680)
			if [[ $(gcc-major-version) -ge 15 ]]; then
				test_build_deselect+=(
					"decisions-neg-delta-json"
					"noncode-json"
					"simple1-txt"
					"simple1-json"
				)
			fi
		;;
		clang) cc_ver="$(clang-major-version)";;
		# Placeholder since tests need CC_REFERENCE to be string-number
		*) cc_ver=1;;
	esac

	readarray -t EPYTEST_DESELECT < <(printf 'tests/test_gcovr.py::test_build[%s]\n' "${test_build_deselect[@]}")

	EPYTEST_DESELECT+=(
		# tests that don't work in the ebuild environment
		gcovr/tests/test_args.py::test_html_template_dir
		gcovr/tests/test_args.py::test_multiple_output_formats_to_stdout
		gcovr/tests/test_args.py::test_multiple_output_formats_to_stdout_1
	)
	local -x CC_REFERENCE="${cc}-${cc_ver}"

	epytest tests
}
