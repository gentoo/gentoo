# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic

DESCRIPTION="Reports network interface statistics"
HOMEPAGE="https://www.frenchfries.net/paul/tcpstat/"
SRC_URI="
	${HOMEPAGE}${P/_p*}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-$(ver_cut 4).debian.tar.xz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6"

DEPEND="
	net-libs/libpcap
	sys-libs/db:*
"
RDEPEND="
	${DEPEND}
"
DOCS=( AUTHORS ChangeLog NEWS README doc/Tips_and_Tricks.txt )
PATCHES=(
	"${FILESDIR}"/${P}-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${P}-ipv6.patch
	"${FILESDIR}"/${P}-libpcap.patch
	"${FILESDIR}"/${P}-off-by-one.patch
	"${FILESDIR}"/${P}-unused.patch
)
S=${WORKDIR}/${P/_p*}

src_prepare() {
	eapply $(
		for patch in $(cat "${WORKDIR}"/debian/patches/series)
			do echo "${WORKDIR}"/debian/patches/${patch}
		done
		) ${PATCHES[@]}
	eapply_user

	eautoreconf
}

src_configure() {
	append-cflags -Wall -Wextra
	econf \
		$(use_enable ipv6) \
		--with-pcap-include='' \
		--with-pcap-lib="$( $(tc-getPKG_CONFIG) --libs libpcap)"
}

src_install() {
	default
	dobin src/{catpcap,packetdump}
	newdoc src/README README.src
}
