# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

EGIT_REPO_URI="https://gitlab.zapb.de/zapb/libjaylink.git"

inherit git-r3 autotools eutils

DESCRIPTION="Library to access J-Link devices"
HOMEPAGE="https://gitlab.zapb.de/zapb/libjaylink"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf || die
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
