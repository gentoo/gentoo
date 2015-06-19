# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/pyclewn/pyclewn-2.1.ebuild,v 1.1 2015/06/16 04:01:46 robbat2 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit eutils vim-plugin distutils-r1

SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

DESCRIPTION="Pyclewn allows using vim as a front end to a debugger (pdb or gdb)"
HOMEPAGE="http://pyclewn.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

CDEPEND="|| (
	>=app-editors/vim-7.3[${PYTHON_USEDEP}]
	>=app-editors/gvim-7.3[netbeans,${PYTHON_USEDEP}]
)"
DEPEND="${CDEPEND}
	app-arch/vimball
"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep \
		'dev-python/trollius[${PYTHON_USEDEP}]' python{2_7,3_3})
"

SLOT="0"

#Completely broken (runs vim), disable for now
#python_test() {
#	esetup.py test
#}

python_install_all() {
	distutils-r1_python_install_all

	vimball -x -C "${ED}"/usr/share/vim/vimfiles lib/clewn/runtime/${P}.vmb || die "Extracting vimball failed"
}

pkg_postinst() {
	vim-plugin_pkg_postinst

	optfeature "C/C++ debugging" sys-devel/gdb
	optfeature "Python debugging" dev-python/pdb-clone
}
