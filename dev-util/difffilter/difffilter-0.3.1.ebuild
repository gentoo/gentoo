# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/difffilter/difffilter-0.3.1.ebuild,v 1.4 2014/08/07 16:45:44 mgorny Exp $

EAPI=3

inherit autotools-utils

DESCRIPTION="Filter files out of unified diffs using POSIX extended regular expressions"
HOMEPAGE="http://ohnopub.net/~ohnobinki/difffilter/"
SRC_URI="ftp://ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="doc"

RDEPEND=">=dev-libs/liblist-2.3.1
	dev-libs/libstrl
	dev-libs/tre"
DEPEND="doc? ( app-text/txt2man )
	${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
	)

	autotools-utils_src_configure
}
