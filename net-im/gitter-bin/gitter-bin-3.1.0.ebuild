# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/-bin/}"

inherit eutils gnome2-utils unpacker

DESCRIPTION="Chat and network platform"
HOMEPAGE="http://www.gitter.im/"
SRC_URI="
	amd64? ( https://update.gitter.im/linux64/${MY_PN}_${PV}_amd64.deb )
	x86? ( https://update.gitter.im/linux32/${MY_PN}_${PV}_i386.deb )"
LICENSE="MIT no-source-code"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="bindist mirror"

RDEPEND="dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	sys-apps/dbus:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libnotify:0
	x11-libs/libX11:0
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXtst:0
	x11-libs/pango:0"

QA_PREBUILT="/opt/${MY_PN}/${MY_PN^}"

S="${WORKDIR}"

src_prepare() {
	local arch=$(usex amd64 "64" "32")

	default
	# Modify desktop file to use common paths
	sed -i \
		-e '/Exec/s/=.*/=\/usr\/bin\/gitter/' \
		-e '/Icon/s/=.*/=\/usr\/share\/pixmaps\/gitter.png/' \
		opt/${MY_PN^}/linux${arch}/${MY_PN}.desktop || die "sed failed"
}

src_install() {
	local arch=$(usex amd64 "64" "32")

	insinto /usr/share/pixmaps
	newins opt/${MY_PN^}/linux${arch}/logo.png ${MY_PN}.png

	newicon -s 256 opt/${MY_PN^}/linux${arch}/logo.png ${MY_PN}.png
	domenu opt/${MY_PN^}/linux${arch}/${MY_PN}.desktop

	insinto /opt/${MY_PN}
	doins opt/${MY_PN^}/linux${arch}/{Gitter,icudtl.dat,libffmpegsumo.so,nw.pak}
	insinto /opt/${MY_PN}/locales
	doins -r opt/${MY_PN^}/linux${arch}/locales/.
	fperms +x /opt/${MY_PN}/${MY_PN^}
	dosym /opt/${MY_PN}/${MY_PN^} /usr/bin/${MY_PN}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
