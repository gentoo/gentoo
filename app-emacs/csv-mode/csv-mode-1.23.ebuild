# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="A major mode for editing comma-separated value files"
HOMEPAGE="https://elpa.gnu.org/packages/csv-mode.html
	https://www.emacswiki.org/emacs/CsvMode"

# Taken from "https://elpa.gnu.org/packages/${P}.tar".
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert . -l "${PN}-tests.el"
