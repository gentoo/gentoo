# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit vim-plugin distutils-r1 optfeature

SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

DESCRIPTION="Pyclewn allows using vim as a front end to a debugger (pdb or gdb)"
HOMEPAGE="http://pyclewn.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

SLOT="0"

CDEPEND="|| (
	app-editors/vim
	app-editors/gvim[netbeans]
)"

DEPEND="
	${CDEPEND}
	app-arch/vimball"

RDEPEND="
	${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	default

	# async in a now a reserved keyword.
	sed -e 's#async#_async#g;' \
		-i lib/clewn/gdb.py || die "can't patch gdb.py"
}

python_install_all() {
	distutils-r1_python_install_all
	python_optimize

	vimball -x -C "${ED}"/usr/share/vim/vimfiles lib/clewn/runtime/${P}.vmb || die "Extracting vimball failed"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	optfeature "C/C++ debugging" sys-devel/gdb
	optfeature "Python debugging" dev-python/pdb-clone
}
