# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="A Python wrapper for the Amazon web API"
HOMEPAGE="http://www.josephson.org/projects/pyamazon"
SRC_URI="http://www.josephson.org/projects/${PN}/files/${P}.zip"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""
RESTRICT_PYTHON_ABIS="3.*"

src_prepare() {
	edos2unix ${PN}/amazon.py
}

src_install() {
	installation() {
		insinto $(python_get_sitedir)
		doins ${PN}/amazon.py
	}
	python_execute_function installation
}

pkg_postinst() {
	python_mod_optimize amazon.py
}

pkg_postrm() {
	python_mod_cleanup amazon.py
}
