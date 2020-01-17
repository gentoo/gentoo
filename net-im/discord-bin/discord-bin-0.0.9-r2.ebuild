# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils pax-utils xdg

MY_PN="${PN%-bin}"
MY_BIN="${MY_PN/d/D}"

DESCRIPTION="All-in-one voice and text chat for gamers"
HOMEPAGE="https://discordapp.com"
SRC_URI="https://dl.discordapp.net/apps/linux/${PV}/${MY_PN}-${PV}.tar.gz"
LICENSE="Discord-TOS"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ayatana +system-ffmpeg"
RESTRICT="bindist strip test"

BDEPEND="dev-util/bsdiff"

RDEPEND="
	app-accessibility/at-spi2-core[X]
	dev-libs/libffi
	dev-libs/libpcre
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/harfbuzz[graphite]
	net-dns/libidn2
	net-libs/gnutls[idn]
	x11-libs/gtk+:3[cups,X]
	x11-libs/libXScrnSaver
	x11-libs/pango[X]
	x11-libs/pixman
	ayatana? ( dev-libs/libappindicator:3 )
	system-ffmpeg? ( media-video/ffmpeg[chromium] )
"

S="${WORKDIR}"

QA_PREBUILT="
	opt/discord/${MY_BIN}
	opt/discord/libVkICD_mock_icd.so
	opt/discord/libffmpeg.so
"

src_prepare() {
	default

	sed "s:/usr/share/discord/Discord:${MY_PN}:g" \
		"${MY_BIN}/${MY_PN}.desktop" \
		> "${T}/${MY_PN}.desktop" || die
	mv "${MY_BIN}/${MY_PN}.png" "${T}" || die

	rm "${MY_BIN}/${MY_PN}.desktop" || die
	rm "${MY_BIN}/postinst.sh" || die
	rm "${MY_BIN}"/lib*GL*.so || die
	rm -r "${MY_BIN}/swiftshader" || die

	if use system-ffmpeg; then
		rm "${MY_BIN}/libffmpeg.so" || die
	fi

	# Subject: patch the autostart creation by Discord
	# Description:
	# The execution needs a specific "LD_LIBRARY_PATH" (via a
	# wrapper), and the icon file is not at the same place.
	#
	# -Exec=/opt/discord/Discord
	# +Exec=discord
	# -Icon=/opt/discord/discord.png
	# +Icon=discord
	#
	local -r f="${MY_BIN}/resources/app.asar"
	bspatch "${f}" "${f}" "${FILESDIR}/${P}-${f##*/}.bspatch" || die
}

src_install() {
	doicon -s 256 "${T}/${MY_PN}.png"
	domenu "${T}/${MY_PN}.desktop"

	insinto "/opt/${MY_PN}"
	doins -r "${MY_BIN}"/*
	fperms +x "/opt/${MY_PN}/${MY_BIN}"

	use system-ffmpeg && local -r libpath="/usr/lib64/chromium"
	make_wrapper "${MY_PN}" "/opt/${MY_PN}/${MY_BIN}" "" \
		"${libpath}"
	pax-mark -m "${ED}/opt/${MY_PN}/${MY_PN}"
}
