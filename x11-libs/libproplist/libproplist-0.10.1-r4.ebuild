# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
