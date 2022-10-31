# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_P=spur.py-${PV}
DESCRIPTION="Run commands locally or over SSH using the same interface"
HOMEPAGE="https://github.com/mwilliamson/spur.py"
SRC_URI="
	https://github.com/mwilliamson/spur.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	https://dev.gentoo.org/~andrewammerlaan/${P}-nose2pytest.diff
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]
"

PATCHES=(
	# https://github.com/mwilliamson/spur.py/pull/95
	"${DISTDIR}/${P}-nose2pytest.diff"
)

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# TODO: set up a local SSH server?
	rm tests/{test_ssh,testing}.py || die
}
