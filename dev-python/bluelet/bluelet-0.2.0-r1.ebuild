# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Module for pure Python asynchronous I/O using coroutines"
HOMEPAGE="https://pypi.org/project/bluelet/"
SRC_URI="https://github.com/sampsyo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples"

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		dodoc -r demo
		docompress -x /usr/share/doc/${PF}/demo
	fi
}
