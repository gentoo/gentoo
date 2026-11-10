# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An improved interface to color-moccur for editing"
HOMEPAGE="https://bookshelf.jp/
	https://www.emacswiki.org/emacs/SearchBuffers"
# taken from http://www.bookshelf.jp/elc/moccur-edit.el
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/color-moccur"
DEPEND="${RDEPEND}"

SITEFILE="60${PN}-gentoo.el"
