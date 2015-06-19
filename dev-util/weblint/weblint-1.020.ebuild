# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/weblint/weblint-1.020.ebuild,v 1.15 2008/03/24 14:09:51 coldwind Exp $

DESCRIPTION="syntax and minimal style checker for HTML by Neil Bowers"
SRC_URI="mirror://gentoo/${P}.tar.gz"
HOMEPAGE="http://www.w3.org/Tools/weblint.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

src_install() {
	dobin weblint
	doman weblint.1

	insinto /etc
	doins weblintrc
}
