# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

DESCRIPTION="A usable configuration management system"
HOMEPAGE="https://www.nico.schottelius.org/software/cdist/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

python_install_all() {
	use doc && local HTML_DOCS=( docs/dist/html/*.html docs/dist/html/man{1,7}/*.html )
	distutils-r1_python_install_all

	doman docs/dist/man/man1/*.1 docs/dist/man/man7/*.7
}
