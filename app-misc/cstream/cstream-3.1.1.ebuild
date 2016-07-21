# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

AT_M4DIR="auxdir"
AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="general-purpose stream-handling tool like UNIX dd"
HOMEPAGE="http://www.cons.org/cracauer/cstream.html"
SRC_URI="http://www.cons.org/cracauer/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# this file does not regenerated automatically by autotools-utils eclass
	rm auxdir/missing || die 'failed to remove auxdir/missing'

	autotools-utils_src_prepare
}
