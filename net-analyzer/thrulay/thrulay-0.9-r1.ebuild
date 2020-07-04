# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Measure the capacity of a network by sending a bulk TCP stream over it"
HOMEPAGE="http://www.internet2.edu/~shalunov/thrulay/"
SRC_URI="
	http://www.internet2.edu/~shalunov/thrulay/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

src_prepare() {
	default

	echo 'thrulay thrulayd: libthrulay.la' >> src/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	dodoc doc/thrulay-protocol.txt
	doman doc/thrulay*.[1-8]

	newinitd "${FILESDIR}"/thrulayd-init.d thrulayd
	newconfd "${FILESDIR}"/thrulayd-conf.d thrulayd

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
