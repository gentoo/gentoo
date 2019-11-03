# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-*}"

inherit desktop eutils

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://about.mattermost.com/"

SRC_URI="
	https://github.com/mattermost/desktop/archive/v${PV}.tar.gz -> ${P}.tar.gz
	amd64? ( https://releases.mattermost.com/desktop/${PV}/mattermost-desktop-${PV}-linux-x64.tar.gz )
	x86?   ( https://releases.mattermost.com/desktop/${PV}/mattermost-desktop-${PV}-linux-ia32.tar.gz )
"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	gnome-base/gconf:2
	dev-libs/atk:0
	dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups:0
	sys-apps/dbus:0
	sys-devel/gcc
	sys-libs/glibc:2.2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11:0
	x11-libs/libxcb:0/1.12
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXtst:0
	x11-libs/pango:0"

QA_PREBUILT="
	opt/mattermost-desktop/mattermost-desktop
	opt/mattermost-desktop/libnode.so
	opt/mattermost-desktop/libffmpeg.so
"

DOCS=(
	NOTICE.txt
	LICENSES.chromium.html
	LICENSE.txt
	LICENSE.electron.txt
	README.md
)

src_unpack() {
	unpack ${A}
	use amd64 && mv "${WORKDIR}/mattermost-desktop-${PV}-linux-x64" "${S}"
	use x86 && mv "${WORKDIR}/mattermost-desktop-${PV}-linux-ia32" "${S}"
}

src_install() {
	insinto "/opt/${MY_PN}/locales"
	doins locales/*.pak

	insinto "/opt/${MY_PN}/resources"
	doins resources/*.asar

	insinto "/opt/${MY_PN}"
	doins *.pak *.bin *.dat
	exeinto "/opt/${MY_PN}"
	doexe *.so "${MY_PN}"

	dosym "/opt/${MY_PN}/${MY_PN}" "/usr/bin/${MY_PN}"

	newicon "${S}/icon.svg" "${MY_PN}.svg"
	make_desktop_entry "${MY_PN}" Mattermost "${MY_PN}"

	einstalldocs
}
