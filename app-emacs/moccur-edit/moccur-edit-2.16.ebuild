# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="An improved interface to color-moccur for editing"
HOMEPAGE="http://www.bookshelf.jp/
	http://www.emacswiki.org/emacs/SearchBuffers"
# taken from http://www.bookshelf.jp/elc/moccur-edit.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/color-moccur"
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"
