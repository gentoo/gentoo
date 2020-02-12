# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A Python/GTK wrapper for quilt"
HOMEPAGE="http://gquilt.sourceforge.net/ https://sourceforge.net/projects/gquilt/"
SRC_URI="mirror://sourceforge/gquilt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	$(python_gen_cond_dep '
		dev-python/pygtk:2[${PYTHON_MULTI_USEDEP}]
	')
	|| ( dev-util/quilt dev-vcs/mercurial )"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

PATCHES=( "${FILESDIR}"/${P}-desktopfile.patch )

python_install_all() {
	distutils-r1_python_install_all
	domenu ${PN}.desktop
}

python_install() {
	distutils-r1_python_install
	python_doscript ${PN}
}
