# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="JavaScript minifier"
HOMEPAGE="https://pypi.org/project/jsmin/ https://github.com/tikitu/jsmin/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="amd64 ~riscv x86"
LICENSE="MIT"
SLOT="0"

distutils_enable_tests unittest

src_prepare() {
	sed -e 's/jsmin.is_3/True/' -i jsmin/test.py || die
	distutils-r1_src_prepare
}
