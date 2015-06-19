# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/sbc/sbc-1.2.ebuild,v 1.8 2014/05/13 14:44:06 ago Exp $

EAPI=5
inherit eutils multilib multilib-minimal

DESCRIPTION="An audio codec to connect bluetooth high quality audio devices like headphones or loudspeakers"
HOMEPAGE="http://git.kernel.org/?p=bluetooth/sbc.git http://www.bluez.org/sbc-10/"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc ppc64 x86"
IUSE="static-libs"

# --enable-tester is building src/sbctester but the tarball is missing required
# .wav file to execute it
RESTRICT="test"

DEPEND="virtual/pkgconfig"

DOCS="AUTHORS ChangeLog"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable static-libs static) \
		--disable-tester
}

multilib_src_install_all() {
	prune_libtool_files
}
