# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A Middlebox Detection Tool"
HOMEPAGE="http://www.tracebox.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl sniffer"

RDEPEND="
	>=net-libs/libcrafter-0.3_p20171019
	dev-lang/lua:*
	dev-libs/json-c
	net-libs/libpcap
	curl? ( net-misc/curl )
	sniffer? ( net-libs/libnetfilter_queue )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
"
RESTRICT="test"
PATCHES=(
	"${FILESDIR}"/${PN}-0.4.4-deps.patch
)

src_prepare() {
	default

	sed -i -e '/SUBDIRS/s|noinst||g' Makefile.am || die
	sed -i -e '/DIST_SUBDIRS.*libcrafter/d' noinst/Makefile.am || die

	sed -i \
		-e '/[[:graph:]]*libcrafter[[:graph:]]*/d' \
		-e '/dist_bin_SCRIPTS/d' \
		src/${PN}/Makefile.am \
		|| die

	sed -i \
		-e 's|"crafter.h"|<crafter.h>|g' \
		src/${PN}/PacketModification.h \
		src/${PN}/PartialHeader.h \
		src/${PN}/script.h \
		src/${PN}/${PN}.h \
		|| die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable curl) \
		$(use_enable sniffer)
}
