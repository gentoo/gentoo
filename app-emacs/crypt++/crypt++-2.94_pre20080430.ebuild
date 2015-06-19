# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/crypt++/crypt++-2.94_pre20080430.ebuild,v 1.4 2014/02/14 17:15:01 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Handle all sorts of compressed and encrypted files"
HOMEPAGE="http://www.emacswiki.org/emacs/CryptPlusPlus"
# snapshot from http://cvs.xemacs.org/viewcvs.cgi/XEmacs/packages/xemacs-packages/os-utils/crypt.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

SITEFILE="50${PN}-gentoo.el"
