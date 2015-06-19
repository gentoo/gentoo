# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/inform-mode/inform-mode-1.6.2.ebuild,v 1.1 2015/01/27 18:28:15 ulm Exp $

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
