# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/inform-mode/inform-mode-1.5.8.ebuild,v 1.17 2015/01/27 18:28:15 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="A major mode for editing Inform programs"
HOMEPAGE="http://rupert-lane.org/inform-mode/
	http://www.emacswiki.org/emacs/InformMode"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"
