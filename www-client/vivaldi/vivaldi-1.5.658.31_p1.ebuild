# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"
inherit chromium-2 eutils multilib unpacker toolchain-funcs

VIVALDI_BRANCH="snapshot"

VIVALDI_PN="${PN}-${VIVALDI_BRANCH:-stable}"
VIVALDI_BIN="${PN}${VIVALDI_BRANCH/snapshot/-snapshot}"
VIVALDI_HOME="opt/${VIVALDI_BIN}"
DESCRIPTION="A new browser for our friends"
HOMEPAGE="http://vivaldi.com/"
VIVALDI_BASE_URI="https://downloads.vivaldi.com/${VIVALDI_BRANCH:-stable}/${VIVALDI_PN}_${PV/_p/-}_"
SRC_URI="
	amd64? ( ${VIVALDI_BASE_URI}amd64.deb -> ${P}-amd64.deb )
	x86? ( ${VIVALDI_BASE_URI}i386.deb -> ${P}-i386.deb )
"

LICENSE="Vivaldi"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="bindist mirror"

S=${WORKDIR}

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/openssl-1.0.1:0
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
"

QA_PREBUILT="*"
S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	sed -i \
		-e "s|${VIVALDI_BIN}|${PN}|g" \
		usr/share/applications/${VIVALDI_PN}.desktop \
		usr/share/xfce4/helpers/${VIVALDI_BIN}.desktop || die

	mv usr/share/doc/${VIVALDI_PN} usr/share/doc/${PF} || die
	chmod 0755 usr/share/doc/${PF} || die

	rm \
		_gpgbuilder \
		etc/cron.daily/${VIVALDI_BIN} \
		|| die
	rmdir \
		etc/cron.daily/ \
		etc/ \
		|| die

	local c d
	for d in 16 22 24 32 48 64 128 256; do
		mkdir -p usr/share/icons/hicolor/${d}x${d}/apps || die
		cp \
			${VIVALDI_HOME}/product_logo_${d}.png \
			usr/share/icons/hicolor/${d}x${d}/apps/vivaldi.png || die
	done

	pushd "${VIVALDI_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

}

src_install() {
	mv * "${D}" || die
	dosym /${VIVALDI_HOME}/${PN} /usr/bin/${PN}

	fperms 4711 /${VIVALDI_HOME}/${PN}-sandbox
}
