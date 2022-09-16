# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

# upstream doesn't do tags much
EGIT_COMMIT=220b1d16442eb4b6fafed338ee3b61f698a01e63
DESCRIPTION="A configurable HTML Minifier with safety features"
HOMEPAGE="https://github.com/mankyd/htmlmin"
SRC_URI="
	https://github.com/mankyd/htmlmin/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

distutils_enable_tests setup.py

src_prepare() {
	sed '/prune/d' -i MANIFEST.in || die
	distutils-r1_src_prepare
}
