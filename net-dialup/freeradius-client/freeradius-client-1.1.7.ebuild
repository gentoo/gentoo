# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools-utils

DESCRIPTION="FreeRADIUS Client framework"
HOMEPAGE="http://wiki.freeradius.org/Radiusclient"
SRC_URI="ftp://ftp.freeradius.org/pub/freeradius/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 sparc x86"

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
