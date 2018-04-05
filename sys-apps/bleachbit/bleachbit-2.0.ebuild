# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite(+)"

inherit desktop distutils-r1

DESCRIPTION="Clean junk to free disk space and to maintain privacy"
HOMEPAGE="https://www.bleachbit.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gtk"

RDEPEND="gtk? ( dev-python/pygtk:2[$PYTHON_USEDEP] )"

DEPEND="${RDEPEND}
	sys-devel/gettext"

python_prepare_all() {
	# choose correct Python implementation, bug #465254
	sed -i 's/python/$(PYTHON)/g' po/Makefile || die

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

	doicon ${PN}.png
	domenu ${PN}.desktop
}

pkg_postinst() {
	elog "Bleachbit has optional notification support. To enable, please install:"
	elog ""
	elog "  dev-python/notify-python"
}
