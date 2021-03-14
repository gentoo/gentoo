# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN%-*}"

inherit desktop

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://about.mattermost.com/"

SRC_URI="
	amd64? ( https://releases.mattermost.com/desktop/${PV}/mattermost-desktop-${PV}-linux-x64.tar.gz )
	x86?   ( https://releases.mattermost.com/desktop/${PV}/mattermost-desktop-${PV}-linux-ia32.tar.gz )
"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2[X]
	dev-libs/expat
	dev-libs/nss
	media-libs/alsa-lib
	net-print/cups
	sys-apps/dbus
	x11-libs/gtk+:3[X]
	x11-libs/libXScrnSaver
"

QA_PREBUILT="
	opt/mattermost-desktop/mattermost-desktop
	opt/mattermost-desktop/libnode.so
	opt/mattermost-desktop/libffmpeg.so
	opt/mattermost-desktop/libGLESv2.so
	opt/mattermost-desktop/libEGL.so
"

DOCS=(
	NOTICE.txt
	README.md
)

S="${WORKDIR}"

src_install() {
	if use amd64; then
		cd "${WORKDIR}/mattermost-desktop-${PV}-linux-x64" || die
	elif use x86; then
		cd "${WORKDIR}/mattermost-desktop-${PV}-linux-ia32" || die
	fi

	insinto "/opt/${MY_PN}/locales"
	doins locales/*.pak

	insinto "/opt/${MY_PN}/resources"
	doins resources/*.asar

	insinto "/opt/${MY_PN}"
	doins *.pak *.bin *.dat
	exeinto "/opt/${MY_PN}"
	doexe *.so "${MY_PN}"

	dosym "../../opt/${MY_PN}/${MY_PN}" "/usr/bin/${MY_PN}"

	newicon "./icon.svg" "${MY_PN}.svg"
	make_desktop_entry "${MY_PN}" Mattermost "${MY_PN}"

	einstalldocs
}
