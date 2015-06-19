# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsidplay/libsidplay-1.36.59-r1.ebuild,v 1.9 2014/09/15 08:21:39 ago Exp $

EAPI=4
inherit eutils libtool multilib-minimal

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://critical.ch/distfiles/"
SRC_URI="http://critical.ch/distfiles/${P}.tgz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r6
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

DOCS=( AUTHORS DEVELOPER )

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
	elibtoolize # required for fbsd .so versioning
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs
}
