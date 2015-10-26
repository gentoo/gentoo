# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools-utils

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="http://wiki.freeradius.org/Radiusclient"
SRC_URI="ftp://ftp.freeradius.org/pub/freeradius/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc64 ~x86"

IUSE="scp shadow static-libs"

DEPEND="!net-dialup/radiusclient
	!net-dialup/radiusclient-ng"
RDEPEND="${DEPEND}"

DOCS=( BUGS doc/ChangeLog doc/login.example doc/release-method.txt )

src_configure() {
	local myeconfargs=(
		$(use_enable scp)
		$(use_enable shadow)
		--with-secure-path
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	dodoc README*
	newdoc doc/README README.login.example
	dohtml doc/instop.html
}
