# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="HTTP download tool built atop the HTTP fetcher library"
HOMEPAGE="https://sourceforge.net/projects/fetch/"
SRC_URI="mirror://sourceforge/fetch/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/http-fetcher"

src_prepare() {
	default
	sed -i -e "/^ld_rpath/d" configure || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc -r docs/*.html README INSTALL
}
