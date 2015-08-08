# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Utilities to manage i2o/dtp RAID controllers"
HOMEPAGE="http://i2o.shadowconnect.com/"
# http://cvs.fedoraproject.org/viewvc/rpms/raidutils/devel/
SRC_URI="http://i2o.shadowconnect.com/raidutils/${P}.tar.bz2
	mirror://gentoo/${PN}-rpm.patch.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND=">=sys-kernel/linux-headers-2.6"
RDEPEND=""

src_prepare() {
	epatch "${WORKDIR}"/${PN}-rpm.patch \
		"${FILESDIR}"/${P}-gcc45.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS
	find "${D}" -name '*.la' -delete
}
