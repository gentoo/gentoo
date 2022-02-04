# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
# This is a backport of Python 3.9's importlib.resources
PYTHON_COMPAT=( pypy3 python3_8 )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="https://github.com/python/importlib_resources"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/zipp-3.7.0-r1[${PYTHON_USEDEP}]
	' python3_{8,9} pypy3)"

distutils_enable_tests unittest
distutils_enable_sphinx docs dev-python/rst-linker dev-python/jaraco-packaging

src_configure() {
	grep -q 'build-backend = "setuptools' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "importlib_resources"
		version = "${PV}"
		description = "Read resources from Python packages"
	EOF
}
