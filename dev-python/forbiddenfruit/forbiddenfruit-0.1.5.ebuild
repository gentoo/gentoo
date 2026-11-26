# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_12 )
# tests crash on 3.13+
# https://github.com/clarete/forbiddenfruit/issues/78
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{13..15} python3_{14,15}t )

inherit distutils-r1 pypi

DESCRIPTION="Patch built-in Python objects"
HOMEPAGE="
	https://github.com/clarete/forbiddenfruit/
	https://pypi.org/project/forbiddenfruit/
"

LICENSE="|| ( GPL-3 MIT )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}, as they are broken"
		return
	fi

	local -x FFRUIT_EXTENSION=true
	esetup.py build_ext -b tests/unit

	local EPYTEST_PLUGINS=()
	epytest
}
