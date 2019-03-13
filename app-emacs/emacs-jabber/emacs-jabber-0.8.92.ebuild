# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A Jabber client for Emacs"
HOMEPAGE="http://emacs-jabber.sourceforge.net/
	https://www.emacswiki.org/emacs/JabberEl"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="app-emacs/hexrgb"
DEPEND="${RDEPEND}
	sys-apps/texinfo"

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="jabber.texi"
DOCS="AUTHORS NEWS README"
