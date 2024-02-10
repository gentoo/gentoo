# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 optfeature

DESCRIPTION="Get information about what a Python frame is currently doing"
HOMEPAGE="
	https://github.com/alexmojaki/executing/
	https://pypi.org/project/executing/
"
SRC_URI="
	https://github.com/alexmojaki/executing/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/asttokens-2.1.0[${PYTHON_USEDEP}]
		dev-python/littleutils[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-additional-slow-tests.patch"
)

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		pypy3)
			EPYTEST_DESELECT+=(
				"tests/test_main.py::test_small_samples[46597f8f896f11c5d7f432236344cc7e5645c2a39836eb6abdd2437c0422f0f4.py]"
			)
			;;
		python3.10)
			EPYTEST_DESELECT+=(
				# crashes with infinite recursion (?)
				"tests/test_main.py::test_small_samples[1656dc52edd2385921104de7bb255ca369713f4b8c034ebeba5cf946058109bc.py]"
			)
			;;
	esac
	if ! has_version "dev-python/ipython[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_ipython.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

pkg_postinst() {
	optfeature "getting node's source code" dev-python/asttokens
}
