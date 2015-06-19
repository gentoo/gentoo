# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/encfs/encfs-1.7.5.ebuild,v 1.4 2014/12/26 17:52:17 maekke Exp $

EAPI=2
inherit autotools eutils multilib

DESCRIPTION="An implementation of encrypted filesystem in user-space using FUSE"
HOMEPAGE="https://vgough.github.io/encfs/"
SRC_URI="https://github.com/vgough/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"
IUSE="xattr"

RDEPEND=">=dev-libs/boost-1.34
	>=dev-libs/openssl-0.9.7
	>=dev-libs/rlog-1.4
	>=sys-fs/fuse-2.7.0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig
	xattr? ( sys-apps/attr )
	sys-devel/gettext"

src_prepare() {
	epatch "${FILESDIR}/encfs-1.7.5-fix-pod.patch"
	eautoreconf
}

src_configure() {
	use xattr || export ac_cv_header_attr_xattr_h=no

	econf \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README
	find "${D}" -name '*.la' -delete
}
