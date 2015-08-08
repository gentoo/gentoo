# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils elisp-common eutils

DESCRIPTION="Bicycle Repair Man is the Python Refactoring Browser"
HOMEPAGE="http://bicyclerepair.sourceforge.net/"
SRC_URI="mirror://sourceforge/bicyclerepair/${P}.tar.gz"

LICENSE="icu GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 x86"
IUSE="emacs"

DEPEND="emacs? (
		app-emacs/pymacs
		app-emacs/python-mode
	)"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"
PYTHON_MODNAME="BicycleRepairMan_Idle.py bike bikeemacs.py"

src_prepare() {
	distutils_src_prepare

	# bikeemacs.py contains non-ASCII characters in comments.
	sed -e '1s/$/\t-*- coding: latin-1 -*-/' -i ide-integration/bikeemacs.py || die "sed failed"

	epatch "${FILESDIR}/${P}-idle.patch"
	epatch "${FILESDIR}/${P}-invalid-syntax.patch"
}

src_test() {
	testing() {
		"$(PYTHON)" testall.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	distutils_pkg_postinst
	use emacs && elisp-site-regen
}

pkg_postrm() {
	distutils_pkg_postrm
	use emacs && elisp-site-regen
}
