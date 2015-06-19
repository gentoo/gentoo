# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/regress/regress-1.5.1.ebuild,v 1.8 2015/01/27 19:27:28 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Regression test harness for Emacs Lisp code"
HOMEPAGE="http://www.emacswiki.org/emacs/WikifiedEmacsLispList"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

ELISP_PATCHES="${PV}-regress.el-gentoo.patch"
SITEFILE="50${PN}-gentoo.el"
