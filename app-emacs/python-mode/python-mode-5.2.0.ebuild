# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit elisp

DESCRIPTION="An Emacs major mode for editing Python source"
HOMEPAGE="https://launchpad.net/python-mode"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tgz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 s390 sh x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

S="${WORKDIR}/${PN}"
# doctest-mode has its own package, pycomplete is not yet ready for production
ELISP_REMOVE="doctest-mode.el pycomplete.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="NEWS"

pkg_postinst() {
	elisp-site-regen
	elog "Note that doctest support is split out to app-emacs/doctest-mode."
}
