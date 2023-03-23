# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python binding to the wlroots library using cffi"
HOMEPAGE="
	https://github.com/flacjacket/pywlroots/
	https://pypi.org/project/pywlroots/
"
SRC_URI="
	https://github.com/flacjacket/pywlroots/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# See README for wlroots dep
DEPEND="
	>=dev-python/pywayland-0.4.14[${PYTHON_USEDEP}]
	>=dev-python/xkbcommon-0.2[${PYTHON_USEDEP}]
	=gui-libs/wlroots-$(ver_cut 1-2)*:=
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.15.24-no-import-version-check.patch
)

distutils_enable_tests pytest

python_test() {
	rm -rf wlroots || die
	epytest
}
