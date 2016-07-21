# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib readme.gentoo toolchain-funcs user systemd

DESCRIPTION="uShare is a UPnP (TM) A/V & DLNA Media Server"
HOMEPAGE="http://ushare.geexbox.org/"
SRC_URI="http://ushare.geexbox.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=net-libs/libupnp-1.6.14"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	EPATCH_EXCLUDE="06_all_ushare_disable_sysconf.patch"
	EPATCH_SOURCE="${FILESDIR}" EPATCH_SUFFIX="patch" \
		EPATCH_OPTS="-p1" epatch

	DOC_CONTENTS="Please edit /etc/ushare.conf to set the shared directories
		and other important settings. Check system log if ushare is
		not booting."
}

src_configure() {
	local myconf
	myconf="--prefix=/usr --sysconfdir=/etc --disable-strip --disable-dlna"
	# nls can only be disabled, on by default.
	use nls || myconf="${myconf} --disable-nls"

	# I can't use econf
	# --host is not implemented in ./configure file
	tc-export CC CXX

	./configure ${myconf} || die "./configure failed"
}

src_install() {
	emake DESTDIR="${D}" install
	doman src/ushare.1
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}.init.d.ng ${PN}
	dodoc NEWS README TODO THANKS AUTHORS
	systemd_dounit "${FILESDIR}"/${PN}.service
	readme.gentoo_create_doc
}

pkg_postinst() {
	enewuser ushare
	readme.gentoo_print_elog
	elog
	elog "The config file has been moved to /etc/ushare.conf"
	elog "Please migrate your settings from /etc/conf.d/ushare"
	elog "to /etc/ushare.conf in order to use the ushare init script"
	elog "and systemd unit service."
	elog
}
