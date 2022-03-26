# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_VERSION="96"
CHROMIUM_LANGS="
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
	vi
	zh-CN
	zh-TW
"

inherit chromium-2

MY_P="${PN}-v${PV}"
DESCRIPTION="Framework that lets you call all Node.js modules directly from the DOM"
HOMEPAGE="https://nwjs.io"
SRC_URI="amd64? ( https://dl.nwjs.io/v${PV}/${MY_P}-linux-x64.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/libglvnd
	media-libs/vulkan-loader
	media-video/ffmpeg-chromium:${CHROMIUM_VERSION}
	net-print/cups
	sys-apps/dbus
	sys-apps/util-linux
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango[X]
"

S="${WORKDIR}/${A%.tar.gz}"
DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

src_prepare() {
	default

	# Unbundle some libraries.
	rm -r lib/lib{EGL.so,ffmpeg.so,GLESv2.so,vulkan.so.1} swiftshader/ || die

	cd locales || die
	rm {ar-XB,en-XA}.pak* || die # No flags for pseudo locales.
	chromium_remove_language_paks
}

src_install() {
	insinto "${DIR}"
	doins -r *

	exeinto "${DIR}"
	doexe chrome_crashpad_handler nw

	insinto "${DIR}"/lib
	doins lib/*.json

	exeinto "${DIR}"/lib
	doexe lib/*.so*

	dosym ../../../usr/$(get_libdir)/chromium/libffmpeg.so.${CHROMIUM_VERSION} \
		"${DIR}"/lib/libffmpeg.so

	dosym ../.."${DIR}"/nw /usr/bin/${PN}
}
