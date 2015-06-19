# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/tempo-snippets/tempo-snippets-0.1.5.ebuild,v 1.4 2015/01/27 19:32:26 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Visual insertion of tempo templates"
HOMEPAGE="http://nschum.de/src/emacs/tempo-snippets/
	http://www.emacswiki.org/emacs/TempoSnippets"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
