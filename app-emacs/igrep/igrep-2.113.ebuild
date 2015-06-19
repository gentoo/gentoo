# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/igrep/igrep-2.113.ebuild,v 1.4 2014/02/15 16:54:44 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION='An improved interface to "grep" and "find"'
HOMEPAGE="http://www.emacswiki.org/emacs/GrepMode"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
