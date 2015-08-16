# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="http://dev.yorhel.nl/ncdu/"
SRC_URI="http://dev.yorhel.nl/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="sys-libs/ncurses:5=[unicode]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-missing-header.patch
}
