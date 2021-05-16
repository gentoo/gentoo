# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic git-r3

DESCRIPTION="TCP daemon and set of libraries for usbredir protocol (redirecting USB traffic)"
HOMEPAGE="https://www.spice-space.org/usbredir.html"
EGIT_REPO_URI="https://anongit.freedesktop.org/git/spice/usbredir.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="static-libs"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS="README* TODO *.txt"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# https://bugs.freedesktop.org/show_bug.cgi?id=54643
	append-cflags -Wno-error

	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	# noinst_PROGRAMS
	dobin usbredirtestclient/.libs/usbredirtestclient
}
