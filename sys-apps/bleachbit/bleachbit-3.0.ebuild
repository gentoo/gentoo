# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org"
SRC_URI="https://download.bleachbit.org/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/chardet[$PYTHON_USEDEP]
	dev-python/pygobject:3[$PYTHON_USEDEP]
	dev-python/scandir[$PYTHON_USEDEP]
"
BDEPEND="
	dev-python/setuptools[$PYTHON_USEDEP]
	sys-devel/gettext
"

python_prepare_all() {
	# choose correct Python implementation, bug #465254
	sed -i 's/python/${EPYTHON}/g' po/Makefile || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	emake -C po local
}

python_install() {
	distutils-r1_python_install
	python_newscript ${PN}.py ${PN}
}

python_install_all() {
	distutils-r1_python_install_all
	emake -C po DESTDIR="${D}" install

	# https://bugs.gentoo.org/388999
	insinto /usr/share/bleachbit/cleaners
	doins cleaners/*.xml

	insinto /usr/share/bleachbit
	doins data/app-menu.ui

	doicon ${PN}.png
	domenu ${PN}.desktop
}
