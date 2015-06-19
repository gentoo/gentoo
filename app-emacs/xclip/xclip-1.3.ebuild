# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/xclip/xclip-1.3.ebuild,v 1.1 2014/04/02 19:44:09 ulm Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Emacs Interface to XClip"
HOMEPAGE="http://elpa.gnu.org/packages/xclip.html"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-misc/xclip"

SITEFILE="50${PN}-gentoo.el"
DOC_CONTENTS="To enable xclip-mode, add (xclip-mode 1) to your ~/.emacs file."
