# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="ANSI Color formatting for output in terminal"
HOMEPAGE="
	https://github.com/termcolor/termcolor/
	https://pypi.org/project/termcolor/
"
# rename is for avoiding conflict with dev-cpp/termcolor
SRC_URI="$(pypi_sdist_url) -> ${P}.py.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# avoid dep on coverage (to ignore warnings from coverage)
	sed -i -e '/coverage/d' pyproject.toml || die
}
