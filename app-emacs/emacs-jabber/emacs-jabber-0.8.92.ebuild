# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/emacs-jabber/emacs-jabber-0.8.92.ebuild,v 1.7 2015/01/27 18:04:31 ulm Exp $

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
