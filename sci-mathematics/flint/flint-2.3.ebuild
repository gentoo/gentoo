# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib

DESCRIPTION="Fast Library for Number Theory"
HOMEPAGE="http://www.flintlib.org/"
SRC_URI="http://www.flintlib.org/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/mpfr
	dev-libs/ntl
	sci-libs/mpir
	"
RDEPEND="${DEPEND}"

src_prepare() {
	# Correct lib paths to be multilib-proper #470732
	sed -i -e 's~/lib~/'$(get_libdir)'~' Makefile.in || die
}

src_configure() {
	# handwritten script, needs extra stabbing
	./configure --with-mpir=/usr --with-mpfr=/usr --with-ntl=/usr --prefix="${D}/usr" || die
}
