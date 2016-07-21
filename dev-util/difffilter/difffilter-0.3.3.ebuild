# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="Filter files out of unified diffs using POSIX extended regular expressions"
HOMEPAGE="http://ohnopub.net/~ohnobinki/difffilter/"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${PN}/${P}.tar.bz2"

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
