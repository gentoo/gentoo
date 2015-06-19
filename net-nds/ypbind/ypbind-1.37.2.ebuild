# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/ypbind/ypbind-1.37.2.ebuild,v 1.9 2014/11/11 10:49:32 ago Exp $

EAPI=5
inherit readme.gentoo systemd

MY_P=${PN}-mt-${PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Multithreaded NIS bind service (ypbind-mt)"
HOMEPAGE="http://www.linux-nis.org/nis/ypbind-mt/index.html"
SRC_URI="http://www.linux-nis.org/download/ypbind-mt/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="debug dbus nls slp systemd"

RDEPEND="
	debug? ( dev-libs/dmalloc )
	dbus? ( dev-libs/dbus-glib )
	slp? ( net-libs/openslp )
	systemd? (
		net-nds/rpcbind
		>=net-nds/yp-tools-2.12-r1
		sys-apps/systemd )
	!systemd? (
		net-nds/yp-tools
		|| ( net-nds/portmap net-nds/rpcbind ) )
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"

DOC_CONTENTS="
	If you are using dhcpcd, be sure to add the -Y option to
	dhcpcd_eth0 (or eth1, etc.) to keep dhcpcd from clobbering
	/etc/yp.conf.
"

src_prepare() {
	! use systemd && export ac_cv_header_systemd_sd_daemon_h=no
}

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable slp) \
		$(use_with debug dmalloc) \
		$(use_enable dbus dbus-nm)
}

src_install() {
	default

	insinto /etc
	newins etc/yp.conf yp.conf.example

	newconfd "${FILESDIR}/ypbind.confd-r1" ypbind
	newinitd "${FILESDIR}/ypbind.initd" ypbind
	use systemd && systemd_dounit "${FILESDIR}/ypbind.service"

	readme.gentoo_create_doc
}
