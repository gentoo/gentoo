# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Library for making terminal apps using colors, keyboard input and positioning"
HOMEPAGE="
	https://github.com/jquast/blessed/
	https://pypi.org/project/blessed/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

RDEPEND="
	>=dev-python/wcwidth-0.1.4[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs dev-python/sphinx-rtd-theme

EPYTEST_PLUGINS=()
# tests are flaky with xdist
distutils_enable_tests pytest

python_prepare_all() {
	# Skip those extensions as they don't have a Gentoo package
	# Remove calls to scripts that generate rst files because they
	# are not present in the tarball
	sed -e '/sphinxcontrib.manpage/d' -e '/sphinx_paramlinks/d' \
		-e '/^for script in/,/runpy.run_path/d' \
		-i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local EPYTEST_DESELECT=(
		# fragile to timing
		tests/test_sixel.py::test_sixel_height_and_width_fallback_to_xtwinops
	)

	# COLORTERM must not be truecolor
	# See https://github.com/jquast/blessed/issues/162
	local -x COLORTERM=
	# Ignore coverage options
	epytest --override-ini="addopts="
}
