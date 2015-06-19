# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pdf2svg/pdf2svg-0.2.2.ebuild,v 1.3 2014/03/13 05:47:03 ssuominen Exp $

EAPI=5
inherit eutils

DESCRIPTION="pdf2svg is based on poppler and cairo and can convert pdf to svg files"
HOMEPAGE="http://www.cityinthesky.co.uk/opensource/pdf2svg/"
SRC_URI="http://www.cityinthesky.co.uk/wp-content/uploads/2013/10/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-text/poppler-0.12.3-r3:=[cairo]
	>=x11-libs/cairo-1.2.6:=[svg]
	x11-libs/gtk+:2="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS" # ChangeLog is only for <=0.2.1 and README.md doesn't have anything useful for usage

src_prepare() {
	sed -i \
		-e 's:#include <stdio.h>:#include <stdio.h>\n#include <stdlib.h>:' \
		${PN}.c || die
}
