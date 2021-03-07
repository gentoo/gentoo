# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Visual insertion of tempo templates"
HOMEPAGE="https://nschum.de/src/emacs/tempo-snippets/
	https://www.emacswiki.org/emacs/TempoSnippets"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
