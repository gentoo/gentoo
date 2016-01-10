# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

EGIT_REPO_URI="git://git.zapb.de/libjaylink.git"

inherit git-r3 autotools

DESCRIPTION="Library to access J-Link devices"
HOMEPAGE="http://git.zapb.de/libjaylink.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf || die
}
