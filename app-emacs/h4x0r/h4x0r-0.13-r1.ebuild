# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Aid in writing like a script kiddie does"
HOMEPAGE="https://www.emacswiki.org/emacs/EliteSpeech"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

SITEFILE="50${PN}-gentoo.el"
