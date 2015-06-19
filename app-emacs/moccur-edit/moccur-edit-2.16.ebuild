# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/moccur-edit/moccur-edit-2.16.ebuild,v 1.3 2015/01/27 19:25:20 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="An improved interface to color-moccur for editing"
HOMEPAGE="http://www.bookshelf.jp/
	http://www.emacswiki.org/emacs/SearchBuffers"
# taken from http://www.bookshelf.jp/elc/moccur-edit.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/color-moccur"
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"
