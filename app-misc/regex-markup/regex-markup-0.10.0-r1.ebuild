# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

DESCRIPTION="A tool to color syslog files as well"
HOMEPAGE="http://www.nongnu.org/regex-markup/"
SRC_URI="https://savannah.nongnu.org/download/regex-markup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="examples nls"

PATCHES=(
	"${FILESDIR}/${P}-locale.patch"
)

src_configure() {
	# fix #570960 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	econf \
		--enable-largefile \
		$(use_enable nls)
}

src_install() {
	default
	if use examples; then
		cd examples || die
		emake -f Makefile
	fi
}
