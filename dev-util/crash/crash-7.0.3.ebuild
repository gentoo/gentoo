# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/crash/crash-7.0.3.ebuild,v 1.1 2013/12/06 16:34:19 cardoe Exp $

EAPI=5

inherit eutils

DESCRIPTION="Red Hat crash utility. Used for analyzing kernel core dumps"
HOMEPAGE="http://people.redhat.com/anderson/"
SRC_URI="http://people.redhat.com/anderson/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~ia64 ~ppc64 ~s390 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.1.1-install-fix.patch
}
