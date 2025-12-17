# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=${PN/-/.}
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Models and classes to supplement the stdlib collections module"
HOMEPAGE="
	https://github.com/jaraco/jaraco.collections/
	https://pypi.org/project/jaraco.collections/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/jaraco-text[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_configure() {
	grep -q 'build-backend = "setuptools' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	sed -i -e \
		's/build-backend = .*/build-backend = "flit_core.buildapi"/' \
		-e '/^name = /a\' -e "version = \"${PV}\"" \
		-e '/^dynamic =/d' \
		pyproject.toml || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
