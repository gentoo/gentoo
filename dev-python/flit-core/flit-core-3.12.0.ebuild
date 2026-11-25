# Copyright 2019-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=standalone
PYPI_VERIFY_REPO=https://github.com/pypa/flit
PYTHON_COMPAT=( python3_{11..15} python3_{13..15}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Simplified packaging of Python modules (core module)"
HOMEPAGE="
	https://pypi.org/project/flit-core/
	https://github.com/pypa/flit/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	test? ( dev-python/testpath[${PYTHON_USEDEP}] )
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unbundle deps
	rm -r flit_core/vendor || die
	sed -i -e 's:from \.vendor ::' flit_core/*.py || die
	sed -i -e '/license-files/d' pyproject.toml || die
}
