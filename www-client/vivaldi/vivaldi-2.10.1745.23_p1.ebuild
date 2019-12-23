# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CHROMIUM_LANGS="
	af am ar be bg bn ca cs da de de-CH el en-GB en-US eo es es-419 es-PE et eu
	fa fi fil fr fy gd gl gu he hi hr hu hy id io is it ja jbo ka kn ko ku lt
	lv mk ml mr ms nb nl nn pl pt-BR pt-PT ro ru sc sk sl sq sr sv sw ta te th
	tr uk vi zh-CN zh-TW
"
inherit chromium-2 multilib unpacker toolchain-funcs xdg-utils

#VIVALDI_BRANCH="snapshot"

VIVALDI_PN="${PN}-${VIVALDI_BRANCH:-stable}"
VIVALDI_BIN="${PN}${VIVALDI_BRANCH/snapshot/-snapshot}"
VIVALDI_HOME="opt/${VIVALDI_BIN}"
DESCRIPTION="A browser for our friends"
HOMEPAGE="https://vivaldi.com/"
VIVALDI_BASE_URI="https://downloads.${PN}.com/${VIVALDI_BRANCH:-stable}/${VIVALDI_PN}_${PV/_p/-}_"
SRC_URI="
	amd64? ( ${VIVALDI_BASE_URI}amd64.deb -> ${P}-amd64.deb )
	arm64? ( ${VIVALDI_BASE_URI}arm64.deb -> ${P}-arm64.deb )
	arm? ( ${VIVALDI_BASE_URI}armhf.deb -> ${P}-armhf.deb )
	x86? ( ${VIVALDI_BASE_URI}i386.deb -> ${P}-i386.deb )
"

LICENSE="Vivaldi"
SLOT="0"
KEYWORDS="-* amd64 ~arm ~arm64 x86"
RESTRICT="bindist mirror"

DEPEND="
	virtual/libiconv
"
RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/speex
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
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
	iconv -c -t UTF-8 usr/share/applications/${VIVALDI_PN}.desktop > "${T}"/${VIVALDI_PN}.desktop || die
	mv "${T}"/${VIVALDI_PN}.desktop usr/share/applications/${VIVALDI_PN}.desktop || die

	sed -i \
		-e "s|${VIVALDI_BIN}|${PN}|g" \
		usr/share/applications/${VIVALDI_PN}.desktop \
		usr/share/xfce4/helpers/${VIVALDI_BIN}.desktop || die

	mv usr/share/doc/${VIVALDI_PN} usr/share/doc/${PF} || die
	chmod 0755 usr/share/doc/${PF} || die

	gunzip usr/share/doc/${PF}/changelog.gz || die

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
			usr/share/icons/hicolor/${d}x${d}/apps/${PN}.png || die
	done

	pushd "${VIVALDI_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	eapply_user
}

src_install() {
	mv * "${D}" || die
	dosym /${VIVALDI_HOME}/${PN} /usr/bin/${PN}

	fperms 4711 /${VIVALDI_HOME}/${PN}-sandbox
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
