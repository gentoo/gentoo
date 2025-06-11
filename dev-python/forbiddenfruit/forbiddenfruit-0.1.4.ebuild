# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_TESTED=( python3_{11..12} )
# tests crash on 3.13+
# https://github.com/clarete/forbiddenfruit/issues/78
PYTHON_COMPAT=( "${PYTHON_TESTED[@]}" python3_{13..14} )

inherit distutils-r1 pypi

DESCRIPTION="Patch built-in Python objects"
HOMEPAGE="
	https://github.com/clarete/forbiddenfruit/
	https://pypi.org/project/forbiddenfruit/
"

LICENSE="|| ( GPL-3 MIT )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~riscv ~s390 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_USEDEP}]
		' "${PYTHON_TESTED[@]}")
	)
"

PATCHES=(
	# https://github.com/clarete/forbiddenfruit/pull/79
	# + test case fix from
	# https://github.com/clarete/forbiddenfruit/commit/6eb07cb77bcd3d54c7f09f23f176706d7dfccdef
	"${FILESDIR}/${P}-pytest.patch"
)

python_test() {
	if ! has "${EPYTHON/./_}" "${PYTHON_TESTED[@]}"; then
		einfo "Skipping tests on ${EPYTHON}, as they are broken"
		return
	fi

	local -x FFRUIT_EXTENSION=true
	esetup.py build_ext -b tests/unit

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
