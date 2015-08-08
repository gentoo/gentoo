# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="A Jabber client for Emacs"
HOMEPAGE="http://emacs-jabber.sourceforge.net/
	http://emacswiki.org/emacs/JabberEl"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="app-emacs/hexrgb"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="jabber.texi"
DOCS="AUTHORS NEWS README"
