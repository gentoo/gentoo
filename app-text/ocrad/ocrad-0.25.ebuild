# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ocrad/ocrad-0.25.ebuild,v 1.1 2015/06/04 09:41:29 aballier Exp $

EAPI=5
inherit unpacker toolchain-funcs

DESCRIPTION="GNU Ocrad is an OCR (Optical Character Recognition) program"
HOMEPAGE="http://www.gnu.org/software/ocrad/ocrad.html"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.lz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="$(unpacker_src_uri_depends)"

DOCS="AUTHORS ChangeLog NEWS README"

src_configure() {
	# ./configure is not based on autotools
	./configure \
		CPPFLAGS="${CPPFLAGS}" \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		--prefix=/usr
}

src_install() {
	default
	doman doc/${PN}.1
	doinfo doc/${PN}.info
}
