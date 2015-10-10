# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit autotools eutils multilib

DESCRIPTION="An implementation of encrypted filesystem in user-space using FUSE"
HOMEPAGE="https://vgough.github.io/encfs/"
SRC_URI="https://github.com/vgough/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"
IUSE="xattr nls"

RDEPEND="dev-libs/boost:=
	dev-libs/openssl:0
	>=dev-libs/rlog-1.3
	>=sys-fs/fuse-2.5
	sys-libs/zlib"
# Your libc probably provides xattrs, but to be safe
# we'll dep on sys-apps/attr.  This should be fixed
# if we ever create a virtual/attr.
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	xattr? ( sys-apps/attr )
	nls? ( sys-devel/gettext )"

src_prepare() {
	eautoreconf
}

src_configure() {
	# configure searches for either attr/xattr.h or sys/xattr.h
	use xattr || export ac_cv_header_{attr,sys}_xattr_h=no

	econf \
		$(use_enable nls) \
		--disable-valgrind \
		--enable-openssl \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README.md
	find "${D}" -name '*.la' -delete
}
