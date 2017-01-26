# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A tool for identifying files embedded inside firmware images"
HOMEPAGE="https://github.com/devttys0/binwalk"
SRC_URI="https://github.com/devttys0/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graph"

RDEPEND="
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_USEDEP}]' python2_7)
	graph? ( dev-python/pyqtgraph[opengl,${PYTHON_USEDEP}] )
"

python_install_all() {
	local DOCS=( API.md INSTALL.md README.md )
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "binwalk has many optional dependencies to automatically"
		elog "extract/decompress data, see INSTALL.md for more details."
	fi
}
