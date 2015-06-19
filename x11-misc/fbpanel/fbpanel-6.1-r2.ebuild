# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/fbpanel/fbpanel-6.1-r2.ebuild,v 1.7 2014/03/23 10:00:01 ago Exp $

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="light-weight X11 desktop panel"
HOMEPAGE="http://fbpanel.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~mips ppc ppc64 x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( CHANGELOG CREDITS README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-underlinking.patch
	epatch "${FILESDIR}"/${P}-xlogout.patch
	tc-export CC
}

src_configure() {
	# not autotools based
	echo "./configure --datadir=/usr/share --libdir=/usr/$(get_libdir)"
	./configure --datadir=/usr/share --libdir=/usr/$(get_libdir) || die
}

pkg_postinst() {
	elog "For the volume plugin to work, you need to configure your kernel"
	elog "with CONFIG_SND_MIXER_OSS or CONFIG_SOUND_PRIME or some other means"
	elog "that provide the /dev/mixer device node."
}
