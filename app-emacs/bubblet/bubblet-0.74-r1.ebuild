# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A bubble-popping game"
HOMEPAGE="https://web.archive.org/web/20051217154122/www.gelatinous.com/pld/bubblet.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
