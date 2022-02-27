# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="Context managers by jaraco"
HOMEPAGE="https://github.com/jaraco/jaraco.context"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/.}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ~ppc64 ~riscv ~sparc x86"

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
		name = "jaraco.context"
		version = "${PV}"
		description = "Context managers by jaraco"
	EOF
}
