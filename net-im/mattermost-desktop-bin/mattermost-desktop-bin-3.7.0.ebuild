# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_PN="${PN%-*}"

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

RDEPEND="gnome-base/gconf:2"

S="${WORKDIR}/mattermost-desktop-${PV}"

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

	newicon "${S}/icon.png" "${MY_PN}.png"
	make_desktop_entry "${MY_PN}" Mattermost "${MY_PN}"

	einstalldocs
}
