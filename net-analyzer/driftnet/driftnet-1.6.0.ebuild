# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="Watches network traffic and displays media from TCP streams observed"
HOMEPAGE="http://www.ex-parrot.com/~chris/driftnet/ https://github.com/deiv/driftnet"
SRC_URI="https://github.com/deiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc -sparc ~x86"
IUSE="debug gtk suid test"

RDEPEND="
	net-libs/libpcap
	net-libs/libwebsockets:=[client,http-proxy,socks5]
	gtk? (
		media-libs/giflib:=
		media-libs/libpng:=
		media-libs/libwebp:=
		x11-libs/gtk+:3
	)
"
BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
RESTRICT="!test? ( test )"
DOCS="
	Changelog CREDITS README.md TODO
"
PATCHES=(
	"${FILESDIR}"/${P/p*}-CFLAGS.patch
	"${FILESDIR}"/${PN}-1.3.0-musl-stdint.patch
	"${FILESDIR}"/${PN}-1.6.0-pr56.patch
	"${FILESDIR}"/${PN}-1.6.0-pr57.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable gtk display)
}

src_install() {
	default

	gzip -d "${ED}"/usr/share/man/man1/${PN}.1.gz || die

	if use suid ; then
		elog "marking the no-display driftnet as setuid root."
		fowners root:wheel "/usr/bin/driftnet"
		fperms 710 "/usr/bin/driftnet"
		fperms u+s "/usr/bin/driftnet"
	fi

	mkdir -p "${ED}"/usr/share/driftnet
	mv -v "${ED}"/usr/share/doc/driftnet-*/html "${ED}"/usr/share/driftnet/static-html
}

pkg_postinst() {
	fcaps \
		cap_dac_read_search,cap_net_raw,cap_net_admin \
		"${EROOT}"/usr/bin/driftnet
}
