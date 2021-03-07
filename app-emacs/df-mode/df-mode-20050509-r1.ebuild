# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Minor mode to show space left on devices in the mode line"
HOMEPAGE="https://web.archive.org/web/20061001221337/http://www.coli.uni-saarland.de/~fouvry/software.html
	https://www.emacswiki.org/emacs/DfMode"
# taken from http://www.coli.uni-saarland.de/~fouvry/files/df-mode.el.gz
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
