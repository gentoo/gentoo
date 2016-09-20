# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="Smart line-wrapping with wrap-prefix"
HOMEPAGE="https://elpa.gnu.org/packages/adaptive-wrap.html"
SRC_URI="https://elpa.gnu.org/packages/${P}.el"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"

src_unpack() {
	cp "${DISTDIR}"/${P}.el ${PN}.el || die
}
