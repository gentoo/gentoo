# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/ssh/ssh-20120709.ebuild,v 1.2 2014/03/25 20:40:38 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Directory tracking and special character handling support for SSH sessions in Emacs shell buffers"
HOMEPAGE="http://www.splode.com/~friedman/software/emacs-lisp/index.html#ssh"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

SITEFILE="50${PN}-gentoo.el"
