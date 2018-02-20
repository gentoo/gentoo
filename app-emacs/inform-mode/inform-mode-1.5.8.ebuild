# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A major mode for editing Inform programs"
HOMEPAGE="https://www.rupert-lane.org/inform-mode/
	https://www.emacswiki.org/emacs/InformMode"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"
