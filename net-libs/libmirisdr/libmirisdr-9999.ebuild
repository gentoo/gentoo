# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="git://git.osmocom.org/libmirisdr"
inherit cmake git-r3

DESCRIPTION="Software for the Mirics MSi2500 + MSi001 SDR platform"
HOMEPAGE="http://cgit.osmocom.org/libmirisdr/"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="doc static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	cmake_src_install
	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/libmirisdr.a
}
