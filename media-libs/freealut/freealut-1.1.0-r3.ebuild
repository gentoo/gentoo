# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freealut/freealut-1.1.0-r3.ebuild,v 1.10 2014/11/02 09:06:49 ago Exp $

EAPI=5
inherit eutils autotools multilib-minimal

DESCRIPTION="The OpenAL Utility Toolkit"
HOMEPAGE="http://www.openal.org/"
SRC_URI="http://connect.creativelabs.com/openal/Downloads/ALUT/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	abi_x86_32? (
		!app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
		!<=app-emulation/emul-linux-x86-sdl-20140406
	)
	>=media-libs/openal-1.15.1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Link against openal and pthread
	sed -i -e 's/libalut_la_LIBADD = .*/& -lopenal -lpthread/' src/Makefile.am
	AT_M4DIR="${S}/admin/autotools/m4" eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	dohtml doc/*
	prune_libtool_files
}
