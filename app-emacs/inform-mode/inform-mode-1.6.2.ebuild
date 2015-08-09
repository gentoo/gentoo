# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="A major mode for editing Inform programs"
HOMEPAGE="http://rupert-lane.org/inform-mode/
	http://www.emacswiki.org/emacs/InformMode"
SRC_URI="http://rupert-lane.org/${PN}/releases/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="AUTHORS NEWS README"
