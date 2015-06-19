# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcue/libcue-1.4.0.ebuild,v 1.11 2014/01/14 21:16:34 pacho Exp $

EAPI=4

DESCRIPTION="CUE Sheet Parser Library"
HOMEPAGE="http://libcue.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE="static-libs"

RDEPEND=""
DEPEND="sys-devel/flex
	|| ( dev-util/yacc sys-devel/bison )"

DOCS=( AUTHORS ChangeLog NEWS  )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
