# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mediawiki/mediawiki-2.2.4.1.ebuild,v 1.1 2014/02/18 07:11:07 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="MediaWiki client for Emacs"
HOMEPAGE="https://launchpad.net/mediawiki-el"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
