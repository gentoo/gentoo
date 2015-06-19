# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mic-paren/mic-paren-3.11.ebuild,v 1.3 2013/12/24 12:46:16 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="Advanced highlighting of matching parentheses"
HOMEPAGE="http://www.gnuvola.org/software/j/mic-paren/
	http://www.emacswiki.org/emacs/MicParen"
# taken from http://www.gnuvola.org/software/j/mic-paren/mic-paren.el
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
