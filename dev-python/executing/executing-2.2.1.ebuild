# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{11..14} )
# pypy3.11: https://github.com/alexmojaki/executing/issues/92
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3_11 )

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/asttokens-2.1.0[${PYTHON_USEDEP}]
		dev-python/littleutils[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	if ! has "${EPYTHON}" "${PYTHON_TESTED[@]/_/.}"; then
		einfo "Skipping tests on ${EPYTHON}"
		return
	fi

	local EPYTEST_DESELECT=()
	if ! has_version "dev-python/ipython[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_ipython.py
		)
	fi

	epytest
}

pkg_postinst() {
	optfeature "getting node's source code" dev-python/asttokens
}
