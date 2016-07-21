# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="HTTP download tool built atop the HTTP fetcher library"
HOMEPAGE="http://sourceforge.net/projects/fetch/"
SRC_URI="mirror://sourceforge/fetch/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/http-fetcher-1.0.1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"

src_prepare() {
	default
	sed -i -e "/^ld_rpath/d" configure || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README INSTALL
	dodoc -r docs/*.html
}
