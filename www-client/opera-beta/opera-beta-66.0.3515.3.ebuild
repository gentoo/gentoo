# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CHROMIUM_LANGS="
	be bg bn ca cs da de el en-GB es es-419 fi fil fr fr-CA hi hr hu id it
	ja ko lt lv ms nb nl pl pt-BR pt-PT ro ru sk sr sv sw ta te th tr uk vi
	zh-CN zh-TW
"
inherit chromium-2 multilib unpacker xdg-utils

DESCRIPTION="A fast and secure web browser"
HOMEPAGE="https://www.opera.com/"
LICENSE="OPERA-2014"
SLOT="0"
SRC_URI_BASE="
	https://download1.operacdn.com/pub/
	https://download2.operacdn.com/pub/
	https://download3.operacdn.com/pub/
	https://download4.operacdn.com/pub/
"
SRC_URI="amd64? ("
for uri in ${SRC_URI_BASE}; do
SRC_URI+="
	"${uri}${PN}/${PV}/linux/${PN}_${PV}_amd64.deb"
"
done
SRC_URI+=")"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	net-misc/curl
	net-print/cups
	sys-apps/dbus
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
	x11-libs/libnotify
	x11-libs/pango[X]
"

QA_PREBUILT="*"
S=${WORKDIR}

pkg_setup() {
	OPERA_HOME="usr/$(get_libdir)/${PN}"
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default

	case ${ARCH} in
		amd64)
			mv usr/lib/x86_64-linux-gnu usr/$(get_libdir) || die
			rm -r usr/lib || die
			;;
		x86)
			mv usr/lib/i386-linux-gnu/${PN} usr/$(get_libdir)/ || die
			;;
	esac

	mv usr/share/doc/${PN} usr/share/doc/${PF} || die
	gunzip usr/share/doc/${PF}/changelog.gz || die

	rm usr/bin/${PN} || die

	pushd "${OPERA_HOME}/localization" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	sed -i \
		-e 's|^TargetEnvironment|X-&|g' \
		usr/share/applications/${PN}.desktop || die
}

src_install() {
	mv * "${D}" || die
	dosym ../$(get_libdir)/${PN}/${PN} /usr/bin/${PN}
	fperms 4711 /usr/$(get_libdir)/${PN}/opera_sandbox
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
