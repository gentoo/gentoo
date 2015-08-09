# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils multilib readme.gentoo toolchain-funcs user

DESCRIPTION="uShare is a UPnP (TM) A/V & DLNA Media Server"
HOMEPAGE="http://ushare.geexbox.org/"
SRC_URI="http://ushare.geexbox.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dlna nls"

RDEPEND=">=net-libs/libupnp-1.6.14
	dlna? ( >=media-libs/libdlna-0.2.4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	EPATCH_SOURCE="${FILESDIR}" EPATCH_SUFFIX="patch" \
		EPATCH_OPTS="-p1" epatch

	DOC_CONTENTS="Please edit /etc/conf.d/ushare to set the shared directories
		and other important settings. Check system log if ushare is
		not booting."
}

src_configure() {
	local myconf
	myconf="--prefix=/usr --disable-sysconf --disable-strip $(use_enable dlna)"
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
	newconfd "${FILESDIR}"/ushare.conf.d ushare
	newinitd "${FILESDIR}"/ushare.init.d ushare
	dodoc NEWS README TODO THANKS AUTHORS
	readme.gentoo_create_doc
}

pkg_postinst() {
	enewuser ushare
	readme.gentoo_print_elog
}
