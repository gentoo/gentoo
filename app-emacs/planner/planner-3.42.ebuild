# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Maintain a local Wiki using Emacs-friendly markup"
HOMEPAGE="http://www.emacswiki.org/emacs/PlannerMode"
SRC_URI="http://download.gna.org/planner-el/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
RESTRICT="test"

RDEPEND=">=app-emacs/muse-3.02.6a
	app-emacs/bbdb
	app-emacs/emacs-w3m"
DEPEND="${RDEPEND}
	sys-apps/texinfo"
PDEPEND="app-emacs/remember"

SITEFILE="80${PN}-gentoo.el"
ELISP_TEXINFO="planner-el.texi"
DOCS="AUTHORS COMMENTARY ChangeLog* NEWS README"

src_compile() {
	default
}
