# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

inherit distutils-r1 pypi

DESCRIPTION="Additional functions used by other projects by developer jaraco"
HOMEPAGE="
	https://github.com/jaraco/jaraco.functools/
	https://pypi.org/project/jaraco.functools/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/more-itertools-0.12.0-r1[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/jaraco-classes[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	grep -q 'build-backend = "setuptools' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "jaraco.functools"
		version = "${PV}"
		description = "Functools like those found in stdlib"
	EOF
}

python_install() {
	distutils-r1_python_install
	# rename to workaround a bug in pkg_resources
	# https://bugs.gentoo.org/834522
	mv "${D}$(python_get_sitedir)"/jaraco{_,.}functools-${PV}.dist-info || die
}
