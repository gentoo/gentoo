# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN%-*}"
MY_PV="${PV/_rc/-rc}"

inherit desktop xdg

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://mattermost.com/"

SRC_URI="
	amd64? ( https://releases.mattermost.com/desktop/${MY_PV}/mattermost-desktop-${MY_PV}-linux-x64.tar.gz )
	x86?   ( https://releases.mattermost.com/desktop/${MY_PV}/mattermost-desktop-${MY_PV}-linux-ia32.tar.gz )
"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2[X]
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	x11-libs/pango
"

QA_PREBUILT="
	opt/mattermost-desktop/mattermost-desktop
	opt/mattermost-desktop/libnode.so
	opt/mattermost-desktop/libffmpeg.so
	opt/mattermost-desktop/libGLESv2.so
	opt/mattermost-desktop/libEGL.so
	opt/mattermost-desktop/libvk_swiftshader.so
"

DOCS=(
	NOTICE.txt
)

S="${WORKDIR}"

src_install() {
	if use amd64; then
		cd "${WORKDIR}/mattermost-desktop-${MY_PV}-linux-x64" || die
	elif use x86; then
		cd "${WORKDIR}/mattermost-desktop-${MY_PV}-linux-ia32" || die
	fi

	newicon app_icon.png ${MY_PN}.png

	insinto "/opt/${MY_PN}/locales"
	doins locales/*.pak

	insinto "/opt/${MY_PN}/resources"
	doins resources/*.asar

	insinto "/opt/${MY_PN}"
	doins *.pak *.bin *.dat
	exeinto "/opt/${MY_PN}"
	doexe *.so "${MY_PN}"

	dosym -r "/opt/${MY_PN}/${MY_PN}" "/usr/bin/${MY_PN}"

	make_desktop_entry "${MY_PN}" Mattermost "${MY_PN}"

	einstalldocs
}
