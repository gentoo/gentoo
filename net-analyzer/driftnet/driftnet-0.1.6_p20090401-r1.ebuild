# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils fcaps flag-o-matic toolchain-funcs

DESCRIPTION="Listen to network traffic and pick out images from TCP streams observed"
HOMEPAGE="http://www.ex-parrot.com/~chris/driftnet/"
SRC_URI="https://github.com/downloads/rbu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm64 ppc -sparc x86"
SLOT="0"
IUSE="gtk mp3 suid"

CDEPEND="
	net-libs/libpcap
	gtk? (
		x11-libs/gtk+:2
		virtual/jpeg:0
		media-libs/giflib:=
		media-libs/libpng:=
	)
"

DEPEND="
	${CDEPEND}
	virtual/pkgconfig
"
RDEPEND="
	${CDEPEND}
	mp3? ( media-sound/mpg123 )
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.1.6-giflib-5.patch

	sed -i \
		-e 's:png_set_gray_1_2_4_to_8:png_set_expand_gray_1_2_4_to_8:' \
		png.c || die

	# With newer libpng, --cflags causes build failures.
	sed -i \
		-e 's:pkg-config --cflags libpng:$(PKG_CONFIG) --libs libpng:' \
		-e 's:_BSD_SOURCE:_DEFAULT_SOURCE:g' \
		Makefile || die
}

src_compile() {
	tc-export CC PKG_CONFIG

	if use gtk; then
		emake
		mv driftnet driftnet-gtk || die
		emake clean
	fi

	# build a non-gtk version for all users
	sed -i 's:^\(.*gtk.*\)$:#\1:g' Makefile || die "sed disable gtk failed"
	append-flags -DNO_DISPLAY_WINDOW
	emake
}

src_install() {
	dosbin driftnet
	doman driftnet.1

	use gtk && dosbin driftnet-gtk

	dodoc CHANGES CREDITS README TODO

	if use suid ; then
		elog "marking the no-display driftnet as setuid root."
		fowners root:wheel "/usr/sbin/driftnet"
		fperms 710 "/usr/sbin/driftnet"
		fperms u+s "/usr/sbin/driftnet"
	fi
}

pkg_postinst() {
	fcaps cap_dac_read_search,cap_net_raw,cap_net_admin \
		"${EROOT}"/usr/sbin/driftnet
	use gtk && fcaps cap_dac_read_search,cap_net_raw,cap_net_admin \
		"${EROOT}"/usr/sbin/driftnet-gtk
}
