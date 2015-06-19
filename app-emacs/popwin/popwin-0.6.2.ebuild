# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/popwin/popwin-0.6.2.ebuild,v 1.2 2014/06/07 11:34:58 ulm Exp $

EAPI=5

inherit elisp eutils

DESCRIPTION="Popup window manager for Emacs"
HOMEPAGE="https://github.com/m2ym/popwin-el/"
SRC_URI="https://github.com/m2ym/${PN}-el/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="README.md NEWS.md"

src_unpack() {
	unpack ${A}
	mv m2ym-popwin-el-* ${P} || die
}
