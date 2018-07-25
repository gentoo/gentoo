# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="pdf2svg is based on poppler and cairo and can convert pdf to svg files"
HOMEPAGE="http://www.cityinthesky.co.uk/opensource/pdf2svg/ https://github.com/dawbarton/pdf2svg/"
SRC_URI="https://github.com/dawbarton/pdf2svg/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-text/poppler-0.12.3-r3[cairo]
	>=x11-libs/cairo-1.2.6:=[svg]
	x11-libs/gtk+:2="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS" # ChangeLog is only for <=0.2.1
# and README.md doesn't have anything useful for usage

src_prepare() {
	sed -i \
		-e 's:#include <stdio.h>:#include <stdio.h>\n#include <stdlib.h>:' \
		${PN}.c || die
	default
}
