# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A small Python module for determining appropriate platform-specific dirs"
HOMEPAGE="
	https://pypi.org/project/platformdirs/
	https://github.com/platformdirs/platformdirs/
"
SRC_URI="
	https://github.com/platformdirs/platformdirs/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/appdirs[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	grep -q 'build-backend = "hatchling' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "${PN}"
		version = "${PV}"
		description = 'A small Python package for determining appropriate platform-specific dirs, e.g. a "user data dir".'
	EOF
	# sigh
	cat > src/platformdirs/version.py <<-EOF || die
		__version__ = version = '${PV}'
		__version_tuple__ = version_tuple = (${PV//./, })
	EOF
}
