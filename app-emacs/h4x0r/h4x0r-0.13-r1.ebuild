# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/h4x0r/h4x0r-0.13-r1.ebuild,v 1.7 2014/01/01 16:51:51 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Aid in writing like a script kiddie does"
HOMEPAGE="http://www.emacswiki.org/emacs/EliteSpeech"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"
