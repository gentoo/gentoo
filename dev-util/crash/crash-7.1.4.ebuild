# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://people.redhat.com/anderson/"
SRC_URI="https://people.redhat.com/anderson/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~ia64 ~ppc64 ~s390 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.1.1-install-fix.patch
	epatch "${FILESDIR}"/${PN}-7.1.4-sysmacros.patch #580244
}
