# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Module for pure Python asynchronous I/O using coroutines"
HOMEPAGE="https://pypi.org/project/bluelet/"
SRC_URI="https://github.com/sampsyo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

python_install_all() {
	if use examples; then
		docompress -x usr/share/doc/${P}/demo
		dodoc -r demo/
	fi
}
