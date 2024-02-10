# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${P/_/-}

DESCRIPTION="Basic AX.25 (Amateur Radio) user tools, additional daemons"
HOMEPAGE="http://www.linux-ax25.org"
SRC_URI="http://www.linux-ax25.org/pub/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="
	>=dev-libs/libax25-0.0.12_rc2
	sys-libs/ncurses:=
	virtual/pkgconfig
	!dev-ruby/listen
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	eapply_user
	# fix missing prototype for malloc
	sed -i -e "/^#include /i #include <stdlib.h>" ax25ipd/routing.c || die
	eapply "${FILESDIR}"/${PN}-0.0.8_rc5-tinfo.patch
	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/ax25ipd.rc ax25ipd
	newinitd "${FILESDIR}"/ax25mond.rc ax25mond
	newinitd "${FILESDIR}"/ax25rtd.rc ax25rtd

	rm -rf "${ED}"/usr/share/doc/ax25-apps || die

	dodoc AUTHORS ChangeLog NEWS README ax25ipd/README.ax25ipd \
		ax25rtd/README.ax25rtd ax25ipd/HISTORY.ax25ipd ax25rtd/TODO.ax25rtd

	dodir /var/lib/ax25/ax25rtd
	touch "${ED}"/var/lib/ax25/ax25rtd/ax25_route || die
	touch "${ED}"/var/lib/ax25/ax25rtd/ip_route || die
}
