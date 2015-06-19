# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/ebookmerge/ebookmerge-0.9.3-r1.ebuild,v 1.1 2012/03/20 10:35:01 pacho Exp $

EAPI=4
inherit eutils

DESCRIPTION="Script to manage eBooks in Gentoo"
HOMEPAGE="http://www.josealberto.org/blog/2005/11/28/ebookmerge/"
SRC_URI="mirror://gentoo/${P}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~x86"
IUSE=""

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}/${P}-updates.patch"
}

src_install() {
	newbin ${P} ebookmerge.sh
}

pkg_postinst() {
	elog
	elog "Need help?  Just run:"
	elog "ebookmerge.sh -h"
	elog
	elog "You first must run:"
	elog "ebookmerge.sh -r"
	elog
	elog "Use -m for an alternative mirror."
	elog
}
