# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="ARP server claiming all unassigned addresses (for network monitoring/simulation)"
HOMEPAGE="http://www.citi.umich.edu/u/provos/honeyd/"
SRC_URI="http://www.citi.umich.edu/u/provos/honeyd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="
	>=dev-libs/libdnet-1.4
	>=dev-libs/libevent-0.6
	net-libs/libpcap
	!sys-apps/iproute2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/arpd.c.patch
	"${FILESDIR}"/${P}-libevent.patch

	# bug 337481, replace test on libevent.a with libevent.so
	"${FILESDIR}"/${P}-buildsystem-libevent-test.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--with-libdnet="${EPREFIX}"/usr \
		--with-libevent="${EPREFIX}"/usr
}

src_install() {
	dosbin arpd
	doman arpd.8
}
