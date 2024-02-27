# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Style preserving TOML library"
HOMEPAGE="
	https://github.com/sdispater/tomlkit/
	https://pypi.org/project/tomlkit/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	grep -q 'build-backend = "poetry' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "tomlkit"
		version = "${PV}"
		description = "Style preserving TOML library"
	EOF
}
