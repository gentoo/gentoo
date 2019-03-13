# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools linux-info user

DESCRIPTION="A client implementation of Secure Socket Tunneling Protocol (SSTP)"
HOMEPAGE="http://sstp-client.sourceforge.net/"
SRC_URI="mirror://sourceforge/sstp-client/${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="static"

RDEPEND=">=dev-libs/libevent-2.0.10
	dev-libs/openssl:0=
	net-dialup/ppp:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~NETFILTER_NETLINK"

PATCHES=( "${FILESDIR}/${P}-remove-network-test.patch"
	  "${FILESDIR}/${P}-fix-example.patch"
)
DOCS=( AUTHORS ChangeLog DEVELOPERS NEWS README TODO USING )

pkg_setup() {
	enewgroup sstpc
	enewuser sstpc -1 -1 -1 sstpc
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local PPPD_VER="$(best_version net-dialup/ppp)"
	PPPD_VER=${PPPD_VER#*/*-}		# reduce it to ${PV}-${PR}
	PPPD_VER=${PPPD_VER%%[_-]*}		# main version without beta/pre/patch/revision
	econf \
		--enable-ppp-plugin \
		--enable-group=sstpc \
		--enable-user=sstpc \
		--with-pppd-plugin-dir="/usr/$(get_libdir)/pppd/${PPPD_VER}" \
		--with-runtime-dir="/run/sstpc" \
		$(use_enable static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
