# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils autotools

DESCRIPTION="A Stroke and Gesture recognition Library"
HOMEPAGE="http://www.etla.net/libstroke/"
SRC_URI="http://www.etla.net/libstroke/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="x11-base/xorg-proto
	${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-m4_syntax.patch
	eapply "${FILESDIR}"/${P}-no_gtk1.patch
	eapply "${FILESDIR}"/${P}-autotools.patch
	eapply_user
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc CREDITS ChangeLog README
}
