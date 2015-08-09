# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit autotools

LICENSE="GPL-2"
KEYWORDS="ppc ~sparc x86"
MY_P=mhxd-${PV}

DESCRIPTION="This is a Hotline 1.5+ compatible *nix Hotline Client in CLI. It supports IRC compatibility"
SRC_URI="http://projects.acidbeats.de/${MY_P}.tar.bz2"
HOMEPAGE="http://hotlinex.sf.net/"

IUSE="ssl"

DEPEND="
	ssl? ( >=dev-libs/openssl-0.9.6d )
	>=sys-libs/zlib-1.1.4"

SLOT="0"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	eautoreconf
}

src_compile() {
	econf \
	`use_enable ssl idea` \
	`use_enable ssl cipher` \
	`use_enable ssl hope` \
	`use_enable ssl compress` \
	--enable-hx || die "bad configure"
	emake || die "compile problem"
	make install || die "compile problem"
}

src_install() {
	dodoc AUTHORS INSTALL PROBLEMS README* ChangeLog TODO NEWS run/hx/ghxvars run/hx/ghxvars.jp \
	run/hx/hxrc run/hx/hxvars

	dobin run/hx/bin/hx
}
