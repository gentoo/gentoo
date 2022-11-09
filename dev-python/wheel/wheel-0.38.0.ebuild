# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A built-package format for Python"
HOMEPAGE="
	https://github.com/pypa/wheel/
	https://pypi.org/project/wheel/
"
SRC_URI="
	https://github.com/pypa/wheel/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# unbundle packaging
	rm -r src/wheel/vendored || die
	sed -i -e 's:\.vendored\.::' src/wheel/*.py || die

	distutils-r1_src_prepare
}

src_configure() {
	[[ -e pyproject.toml ]] &&
		die "Upstream added pyproject.toml, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "wheel"
		description = "A built-package format for Python"
		dynamic = ["version"]

		[project.scripts]
		wheel = "wheel.cli:main"

		[project.entry-points."distutils.commands"]
		bdist_wheel = "wheel.bdist_wheel:bdist_wheel"
	EOF
}
