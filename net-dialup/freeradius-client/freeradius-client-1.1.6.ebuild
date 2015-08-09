# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="http://wiki.freeradius.org/Radiusclient"
SRC_URI="ftp://ftp.freeradius.org/pub/freeradius/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scp shadow"

DEPEND="!net-dialup/radiusclient
	!net-dialup/radiusclient-ng"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable scp) \
		$(use_enable shadow) \
		--with-secure-path || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc BUGS README* doc/ChangeLog doc/login.example doc/release-method.txt
	newdoc doc/README README.login.example
	dohtml doc/instop.html
}
