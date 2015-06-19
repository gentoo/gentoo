# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/pov-mode/pov-mode-3.3.ebuild,v 1.1 2012/09/03 20:13:06 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Emacs mode for povray"
HOMEPAGE="http://gitorious.org/pov-mode/"
SRC_URI="http://gitorious.org/${PN}/${PN}/archive-tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${PN}-${PN}"
SITEFILE="50${PN}-gentoo.el"
ELISP_REMOVE="${PN}-pkg.el ${PN}.info"
ELISP_TEXINFO="info/${PN}.texi"
DOCS="README"

src_install() {
	elisp_src_install
	insinto ${SITEETC}/${PN}
	doins *.xpm
	doins -r InsertMenu/
}
