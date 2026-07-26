# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN=${PN^}
PYTHON_FULLY_TESTED=( python3_{12..15} )
PYTHON_COMPAT=( "${PYTHON_FULLY_TESTED[@]}" python3_{13..15}t )

inherit distutils-r1 pypi shell-completion

DESCRIPTION="Pygments is a syntax highlighting package written in Python"
HOMEPAGE="
	https://pygments.org/
	https://github.com/pygments/pygments/
	https://pypi.org/project/Pygments/
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/lxml[${PYTHON_USEDEP}]
			dev-python/pillow[${PYTHON_USEDEP}]
		' "${PYTHON_FULLY_TESTED[@]}")
		dev-python/wcag-contrast-ratio[${PYTHON_USEDEP}]
		virtual/ttf-fonts
	)
"

EPYTEST_DESELECT=(
	# fuzzing tests, very slow
	tests/test_basic_api.py::test_random_input
)

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	newbashcomp external/pygments.bashcomp pygmentize
}
