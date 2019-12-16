# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A major mode for editing comma-separated value files"
HOMEPAGE="https://elpa.gnu.org/packages/csv-mode.html
	https://www.emacswiki.org/emacs/CsvMode"
# Taken from https://elpa.gnu.org/packages/${P}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

SITEFILE="50${PN}-gentoo.el"
