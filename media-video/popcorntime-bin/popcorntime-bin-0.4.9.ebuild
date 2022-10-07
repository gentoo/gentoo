# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 desktop unpacker xdg

DESCRIPTION="BitTorrent client that includes an integrated media player"
HOMEPAGE="https://github.com/popcorn-official/popcorn-desktop"
SRC_URI="
	amd64? ( https://github.com/popcorn-official/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-amd64.deb )
	x86? ( https://github.com/popcorn-official/popcorn-desktop/releases/download/v${PV}/Popcorn-Time-${PV}-i386.deb )
"
S="${WORKDIR}"

KEYWORDS="-* ~amd64 ~x86"
# Electron bundles a bunch of things
LICENSE="
	MIT BSD BSD-2 BSD-4 AFL-2.1 Apache-2.0 Ms-PL GPL-2 LGPL-2.1 APSL-2
	unRAR OFL CC-BY-SA-3.0 MPL-2.0 android public-domain all-rights-reserved
"
SLOT="0"
RESTRICT="bindist mirror"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf
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
	x11-libs/pango
"

QA_PREBUILT="opt/Popcorn-Time/*"

pkg_pretend() {
	chromium_suid_sandbox_check_kernel_config
}

src_prepare() {
	default
	# cleanup languages
	pushd "opt/Popcorn-Time/locales" || die
	chromium_remove_language_paks
	popd || die
}

src_configure() {
	chromium_suid_sandbox_check_kernel_config
	default
}

src_install() {
	doicon -s 256 "usr/share/icons/butter.png"

	domenu usr/share/applications/Popcorn-Time.desktop

	local DESTDIR="/opt/Popcorn-Time"
	pushd "opt/Popcorn-Time" || die

	# Copy all the things in
	dodir "${DESTDIR}"
	mv * "${ED}/${DESTDIR}" || die

	dosym "${DESTDIR}"/Popcorn-Time /opt/bin/Popcorn-Time
	popd || die
}
