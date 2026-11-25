# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{12..15} python3_{14..15}t )
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" pypy3_12 )

inherit distutils-r1

DESCRIPTION="A library for computing contrast ratios, as required by WCAG 2.0"
HOMEPAGE="
	https://github.com/gsnedders/wcag-contrast-ratio/
	https://pypi.org/project/wcag-contrast-ratio/
"
SRC_URI="
	https://github.com/gsnedders/wcag-contrast-ratio/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/hypothesis[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping testing on ${EPYTHON}"
		return
	fi

	local EPYTEST_PLUGINS=( hypothesis )
	epytest test.py
}
