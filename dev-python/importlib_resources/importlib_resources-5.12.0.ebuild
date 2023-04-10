# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=flit
# This is a backport of importlib.resources that's present since py3.9.
# However, the version in 3.9 is buggy, so matplotlib needs it on 3.9
# as well.
PYTHON_COMPAT=( pypy3 python3_9 )

inherit distutils-r1

DESCRIPTION="Read resources from Python packages"
HOMEPAGE="
	https://github.com/python/importlib_resources/
	https://pypi.org/project/importlib-resources/
"
SRC_URI="
	https://github.com/python/importlib_resources/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/zipp-3.7.0-r1[${PYTHON_USEDEP}]
	' 3.8 3.9)
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
		name = "importlib_resources"
		version = "${PV}"
		description = "Read resources from Python packages"
	EOF
}
