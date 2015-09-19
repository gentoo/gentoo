# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 elisp-common

DESCRIPTION="Bicycle Repair Man is the Python Refactoring Browser"
HOMEPAGE="http://bicyclerepair.sourceforge.net/"
SRC_URI="mirror://sourceforge/bicyclerepair/${P}.tar.gz"

LICENSE="icu GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ppc64 ~x86"
IUSE="emacs"

DEPEND="emacs? (
		app-emacs/pymacs[${PYTHON_USEDEP}]
		app-emacs/python-mode )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

python_prepare_all() {
	# bikeemacs.py contains non-ASCII characters in comments.
	sed -e '1s/$/\t-*- coding: latin-1 -*-/' -i ide-integration/bikeemacs.py || die "sed failed"
	epatch "${FILESDIR}/${P}-idle.patch"
	epatch "${FILESDIR}/${P}-invalid-syntax.patch"

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" testall.py || die
}

src_install() {
	distutils-r1_src_install

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die "elisp-site-file-install failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
