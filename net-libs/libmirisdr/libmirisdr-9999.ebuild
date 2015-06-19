# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmirisdr/libmirisdr-9999.ebuild,v 1.2 2013/06/17 02:31:35 zerochaos Exp $

EAPI=5
inherit cmake-utils git-2 multilib

DESCRIPTION="Software for the Mirics MSi2500 + MSi001 SDR platform"
HOMEPAGE="http://cgit.osmocom.org/libmirisdr/"
EGIT_REPO_URI="git://git.osmocom.org/libmirisdr"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="doc static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	cmake-utils_src_install
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libmirisdr.a
}
