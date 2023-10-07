# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Persist variables between Emacs sessions"
HOMEPAGE="https://elpa.gnu.org/packages/persist.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# ELISP_TEXINFO="${PN}.texi"    # Broken.
SITEFILE="50${PN}-gentoo.el"
