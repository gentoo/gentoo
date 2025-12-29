# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fcaps

DESCRIPTION="Watches network traffic and displays media from TCP streams observed"
HOMEPAGE="https://chris.ex-parrot.com/driftnet/"
SRC_URI="https://github.com/deiv/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc -sparc ~x86"
IUSE="debug gtk httpd suid test"
RESTRICT="!test? ( test )"

RDEPEND="
	net-libs/libpcap
	media-libs/libwebp:=
	gtk? (
		dev-libs/glib:2
		media-libs/giflib:=
		media-libs/libjpeg-turbo:=
		media-libs/libpng:=
		x11-libs/cairo
		x11-libs/gtk+:3[X]
	)
	httpd? ( net-libs/libwebsockets:=[client,http-proxy,socks5] )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# Respect user flags
	"${FILESDIR}"/${PN}-1.6.0-CFLAGS.patch
	# https://github.com/deiv/driftnet/pull/56.patch
	"${FILESDIR}"/${PN}-1.5.0-fix_test.patch
	"${FILESDIR}"/${PN}-1.5.0-use_uint.patch
	# https://github.com/deiv/driftnet/pull/57.patch
	"${FILESDIR}"/${PN}-1.5.0-libwebsocket_compat.patch
)

FILECAPS=( cap_dac_read_search,cap_net_raw,cap_net_admin usr/bin/driftnet )

# EXTRA_DIST
DOCS=( Changelog CREDITS )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable gtk display)
		$(use_enable httpd http-display)
		--htmldir="${EPREFIX}"/usr/share/driftnet/static-html
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	gzip -d "${ED}"/usr/share/man/man1/${PN}.1.gz || die

	if use suid ; then
		elog "marking driftnet as setuid root."
		fowners root:wheel "/usr/bin/driftnet"
		fperms 710 "/usr/bin/driftnet"
		fperms u+s "/usr/bin/driftnet"
	fi
}
