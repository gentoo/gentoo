# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A lightweight streaming audio player for Logitech Media Server"
HOMEPAGE="https://squeezeslave.googlecode.com"
SRC_URI="https://dev.gentoo.org/~radhermit/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac +alsa display tremor wma zones"

RDEPEND="media-libs/libmad
	media-libs/flac
	tremor? ( media-libs/tremor )
	!tremor? ( media-libs/libvorbis )
	media-libs/libogg
	media-libs/portaudio[alsa?]
	aac? ( virtual/ffmpeg )
	wma? ( virtual/ffmpeg )
	display? ( app-misc/lirc )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1_p350-tremor-headers.patch
	epatch "${FILESDIR}"/${PN}-1.1_p381-ffmpeg2.patch
}

src_compile() {
	tc-export CC AR RANLIB

	local myconf
	for i in aac display tremor wma zones ; do
		use $i && myconf+=" $i=1"
	done

	emake ${myconf}
}

src_install() {
	dobin bin/${PN}
	dodoc ChangeLog TODO

	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}
	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
}
