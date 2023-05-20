# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg-utils

DESCRIPTION="Flash OS images to SD cards & USB drives safely and easily."
HOMEPAGE="https://etcher.io/"
SRC_URI="https://github.com/balena-io/etcher/releases/download/v${PV}/balena-etcher_${PV}_amd64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+sound"
RESTRICT="splitdebug strip"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[X(+)]
	net-print/cups
	sys-apps/dbus[X]
	x11-libs/cairo
	x11-libs/gtk+:3[X]
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
	sound? (
		|| (
			media-sound/pulseaudio
			media-sound/apulse
		)
	)
"

S="${WORKDIR}"

QA_PREBUILT="/opt/balenaEtcher/*"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	mv * "${D}" || die
	# Don't install changelog
	rm -rf "${D}"/usr/share/doc/ || die
	fperms 0755 /opt/balenaEtcher/balena-etcher || die
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
