# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libproplist/libproplist-0.10.1-r4.ebuild,v 1.3 2012/07/08 16:23:36 armin76 Exp $

EAPI=4

MY_P=libPropList-${PV}

inherit autotools eutils

DESCRIPTION="An library to mimic property list functionality from the GNUstep environment"
HOMEPAGE="http://windowmaker.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog README TODO )

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-include.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/libPropList.la
}
