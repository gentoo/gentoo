# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/rpm-spec-mode/rpm-spec-mode-0.15.ebuild,v 1.1 2014/02/22 06:45:53 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Emacs mode to ease editing of RPM spec files"
HOMEPAGE="http://www.emacswiki.org/emacs/RpmSpecMode"
# taken from http://www.tihlde.org/~stigb/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

SITEFILE="50${PN}-gentoo.el"
