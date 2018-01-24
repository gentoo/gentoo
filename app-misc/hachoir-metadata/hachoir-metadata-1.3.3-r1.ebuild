# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Program to extract metadata using Hachoir library"
HOMEPAGE="https://web.archive.org/web/20161220105023/https://bitbucket.org/haypo/hachoir/wiki/hachoir-metadata https://pypi.python.org/pypi/hachoir-metadata"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="gnome gtk"

RDEPEND="
	>=dev-python/hachoir-core-1.3[${PYTHON_USEDEP}]
	>=dev-python/hachoir-parser-1.3[${PYTHON_USEDEP}]
	gtk? ( >=dev-python/pygtk-2.0[${PYTHON_USEDEP}] )
	gnome? ( gnome-base/nautilus gnome-extra/zenity )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	if ! use gtk; then
		sed -i -e '/SCRIPTS/s:, "hachoir-metadata-gtk"::' setup.py || die
	fi

	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=( --setuptools --disable-qt )
}

python_test() {
	"${PYTHON}" test_doc.py || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	if use gnome; then
		exeinto /usr/share/nautilus-scripts
		doexe gnome/hachoir
	fi
}

pkg_postinst() {
	if use gnome; then
		elog "To enable the nautilus script, symlink it with:"
		elog " $ mkdir -p ~/.gnome2/nautilus-scripts"
		elog " $ ln -s /usr/share/nautilus-scripts/hachoir ~/.gnome2/nautilus-script"
	fi
}
