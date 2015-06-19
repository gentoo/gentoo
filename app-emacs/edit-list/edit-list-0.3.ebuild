# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/edit-list/edit-list-0.3.ebuild,v 1.3 2014/02/15 00:28:32 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Edit a single list"
HOMEPAGE="http://mwolson.org/projects/"
# taken from http://mwolson.org/static/dist/elisp/edit-list.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
