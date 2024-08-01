# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P/_/-}"

DESCRIPTION="Basic AX.25 (Amateur Radio) user tools, additional daemons"
HOMEPAGE="
	https://linux-ax25.in-berlin.de/
	https://packet-radio.net/ax-25/
" # NOTE: ...in-berlin.de does not work but subdomains do
SRC_URI="
	https://linux-ax25.in-berlin.de/pub/${PN}/${MY_P}.tar.gz
	https://ham.packet-radio.net/packet/ax25/ax25-apps/${MY_P}.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-libs/libax25-0.0.12_rc2:=
	sys-libs/ncurses:=
	!dev-ruby/listen
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	# fix missing prototype for malloc
	sed -i -e "/^#include /i #include <stdlib.h>" ax25ipd/routing.c || die
	eapply "${FILESDIR}"/${PN}-0.0.8_rc5-tinfo.patch
	eapply_user
	eautoreconf
}

src_install() {
	default

	newinitd "${FILESDIR}"/ax25ipd.rc ax25ipd
	newinitd "${FILESDIR}"/ax25mond.rc ax25mond
	newinitd "${FILESDIR}"/ax25rtd.rc ax25rtd

	# HACK: one should not create instead of removing
	rm -r "${ED}"/usr/share/doc/${PF} || die

	dodoc AUTHORS ChangeLog NEWS README ax25ipd/README.ax25ipd \
		ax25rtd/README.ax25rtd ax25ipd/HISTORY.ax25ipd ax25rtd/TODO.ax25rtd

	dodir /var/lib/ax25/ax25rtd
	touch "${ED}"/var/lib/ax25/ax25rtd/ax25_route || die
	touch "${ED}"/var/lib/ax25/ax25rtd/ip_route || die
}
