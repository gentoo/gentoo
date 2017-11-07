# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit systemd

DESCRIPTION="Network Information Service tools"
HOMEPAGE="http://www.linux-nis.org/nis/"
SRC_URI="http://www.linux-nis.org/download/yp-tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="nls"

DEPEND="
	|| ( <sys-libs/glibc-2.26[rpc] net-libs/libtirpc )
	net-libs/libnsl:0=
"
RDEPEND=${DEPEND}
# uses always libtirpc if present

RESTRICT=test # do not compile

src_configure () {
	econf \
		--disable-static \
		--sysconfdir=/etc/yp \
		$(use_enable nls)
}

src_install() {
	default

	insinto /etc/yp
	doins etc/nicknames

	systemd_dounit "${FILESDIR}/domainname.service"
	systemd_install_serviced "${FILESDIR}"/domainname.service.conf
}
