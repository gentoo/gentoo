# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dictionary/dictionary-1.10.ebuild,v 1.5 2014/11/15 10:20:11 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Emacs package for talking to a dictionary server"
HOMEPAGE="http://www.myrkr.in-berlin.de/dictionary/index.html"
SRC_URI="http://www.myrkr.in-berlin.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

ELISP_REMOVE="install-package.el lpath.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README"
