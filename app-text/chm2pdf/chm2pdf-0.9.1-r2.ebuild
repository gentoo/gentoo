# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit python-single-r1

DESCRIPTION="A script that converts a CHM file into a single PDF file"
HOMEPAGE="https://code.google.com/p/chm2pdf/"
EGIT_REPO_URI="https://github.com/mesonbuild/meson"
inherit git-r3

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pychm[${PYTHON_USEDEP}]
	app-text/htmldoc
	>=dev-libs/chmlib-0.40-r1[examples]
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare(){
	python_fix_shebang .
}

src_install() {
	default
	python_doscript ${PN} || die "failed to create executable"
}
