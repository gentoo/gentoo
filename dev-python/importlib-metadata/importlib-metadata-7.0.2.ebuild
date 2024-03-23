# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
# NB: this package extends beyond built-in importlib stuff in py3.8+
# new entry_point API not yet included in cpython release
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Read metadata from Python packages"
HOMEPAGE="
	https://github.com/python/importlib_metadata/
	https://pypi.org/project/importlib-metadata/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	dev-python/zipp[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pyfakefs[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_configure() {
	grep -q 'build-backend = "setuptools' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "importlib_metadata"
		version = "${PV}"
		description = "Read metadata from Python packages"
	EOF
}
