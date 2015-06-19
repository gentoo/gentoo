# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/graphviz-dot-mode/graphviz-dot-mode-0.3.7.ebuild,v 1.6 2014/02/16 13:04:55 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	http://www.graphviz.org/"
# taken from http://users.skynet.be/ppareit/projects/${PN}/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

SITEFILE="50${PN}-gentoo.el"
