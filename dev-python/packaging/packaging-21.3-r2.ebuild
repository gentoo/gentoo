# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Core utilities for Python packages"
HOMEPAGE="
	https://github.com/pypa/packaging/
	https://pypi.org/project/packaging/"
SRC_URI="
	https://github.com/pypa/packaging/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

SLOT="0"
LICENSE="|| ( Apache-2.0 BSD-2 )"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-python/pyparsing-3.0.7-r1[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "packaging"
		dynamic = ["version"]
		description = "More routines for operating on iterables, beyond itertools"
	EOF
}

python_test() {
	epytest --capture=no
}
