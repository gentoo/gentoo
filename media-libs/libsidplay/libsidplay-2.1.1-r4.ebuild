# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils libtool multilib-minimal

MY_P=sidplay-libs-${PV}

DESCRIPTION="C64 SID player library"
HOMEPAGE="http://sidplay2.sourceforge.net/"
SRC_URI="mirror://sourceforge/sidplay2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"
RDEPEND="abi_x86_32? ( !<=app-emulation/emul-linux-x86-medialibs-20130224-r6
		!app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)] )"

S=${WORKDIR}/${MY_P}

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/sidplay/sidconfig.h
)

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}2-gcc41.patch \
		"${FILESDIR}"/${P}-fbsd.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-no_libtool_reference.patch

	elibtoolize
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static) \
		--with-pic
}

multilib_src_install_all() {
	docinto libsidplay
	dodoc libsidplay/{AUTHORS,ChangeLog,README,TODO}

	docinto libsidutils
	dodoc libsidutils/{AUTHORS,ChangeLog,README,TODO}

	docinto resid
	dodoc resid/{AUTHORS,ChangeLog,NEWS,README,THANKS,TODO}

	doenvd "${FILESDIR}"/65resid

	prune_libtool_files --all
}
