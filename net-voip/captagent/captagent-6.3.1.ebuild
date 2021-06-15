# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="100% Open-Source Packet Capture Agent for HEP"
HOMEPAGE="https://sipcapture.org/ https://github.com/sipcapture/captagent"
SRC_URI="https://github.com/sipcapture/captagent/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 mysql pcre redis ssl"

PATCHES=(
	# https://github.com/sipcapture/captagent/pull/239 (should be accepted).
	"${FILESDIR}/${P}-gcc10.patch"
	# Already upstreamed for next version.
	"${FILESDIR}/${P}-configure.patch"
)

DEPEND="dev-libs/json-c
	net-libs/libpcap
	dev-libs/libuv
	mysql? ( dev-db/mysql-connector-c )
	pcre? ( dev-libs/libpcre )
	redis? ( dev-db/redis )
	ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-compression \
		--disable-epan \
		$(use_enable ipv6) \
		$(use_enable mysql) \
		$(use_enable pcre) \
		$(use_enable redis) \
		$(use_enable ssl tls) \
		$(use_enable ssl)
}
