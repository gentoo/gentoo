# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#CHROMIUM_VERSION="123"
CHROMIUM_LANGS="
	af
	am
	ar
	bg
	bn
	ca
	cs
	da
	de
	el
	en-GB
	en-US
	es-419
	es
	et
	fa
	fil
	fi
	fr
	gu
	he
	hi
	hr
	hu
	id
	it
	ja
	kn
	ko
	lt
	lv
	ml
	mr
	ms
	nb
	nl
	pl
	pt-BR
	pt-PT
	ro
	ru
	sk
	sl
	sr
	sv
	sw
	ta
	te
	th
	tr
	uk
	ur
	vi
	zh-CN
	zh-TW
"

inherit chromium-2

DESCRIPTION="Framework that lets you call all Node.js modules directly from the DOM"
HOMEPAGE="https://nwjs.io"
SRC_URI="
	sdk? (
		amd64? ( https://dl.nwjs.io/v${PV}/${PN}-sdk-v${PV}-linux-x64.tar.gz )
		x86? ( https://dl.nwjs.io/v${PV}/${PN}-sdk-v${PV}-linux-ia32.tar.gz )
	)
	!sdk? (
		amd64? ( https://dl.nwjs.io/v${PV}/${PN}-v${PV}-linux-x64.tar.gz )
		x86? ( https://dl.nwjs.io/v${PV}/${PN}-v${PV}-linux-ia32.tar.gz )
	)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="sdk"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[opengl]
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrandr
	x11-libs/pango
	virtual/libudev
	|| ( gui-libs/gtk:4 x11-libs/gtk+:3 )
	!<games-rpg/crosscode-1.4.2.2-r1
	<media-video/ffmpeg-7:0/58.60.60[chromium]
"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

src_unpack() {
	default
	if use amd64; then
		mv "${WORKDIR}/${PN}-$(usev sdk "sdk-")v${PV}-linux-x64" "${S}" || die
	elif use x86; then
		mv "${WORKDIR}/${PN}-$(usev sdk "sdk-")v${PV}-linux-ia32" "${S}" || die
	else
		die "Unsupported architecture"
	fi
}

src_prepare() {
	default

	# Unbundle some libraries. We used to unbundle libEGL, libGLESv2, and
	# libvulkan, but that now causes CrossCode to crash.
	rm -r lib/libffmpeg.so swiftshader/ || die

	cd locales || die
	rm {ar-XB,en-XA}*.pak* || die # No flags for pseudo locales.
	chromium_remove_language_paks
}

src_install() {
	insinto "${DIR}"
	doins -r *

	exeinto "${DIR}"
	doexe chrome_crashpad_handler nw
	use sdk && doexe chromedriver minidump_stackwalk nwjc

	insinto "${DIR}"/lib
	doins lib/*.json

	exeinto "${DIR}"/lib
	doexe lib/*.so*

	dosym ../../../usr/$(get_libdir)/chromium/libffmpeg.so \
		"${DIR}"/lib/libffmpeg.so

	dosym ../.."${DIR}"/nw /usr/bin/${PN}
}
