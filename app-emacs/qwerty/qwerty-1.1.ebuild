# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/qwerty/qwerty-1.1.ebuild,v 1.15 2014/02/18 23:05:53 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Switch between QWERTY and DVORAK without changing the console keymap"
# gnu.emacs.sources Message-ID: <NJ104.93Mar1125218@bootes.cus.cam.ac.uk>
HOMEPAGE="http://groups.google.com/group/gnu.emacs.sources/msg/eab31c752dfdd3a5"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"
