# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python ctypes-based bindings for libvlc"
HOMEPAGE="https://github.com/oaubert/python-vlc"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="examples"

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
