# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://about.mattermost.com/"
SRC_URI="https://github.com/mattermost/desktop/archive/v${PV}.tar.gz -> ${PV}.tar.gz
		 amd64? ( https://releases.mattermost.com/desktop/3.5.0/mattermost-desktop-${PV}-linux-x64.tar.gz )
		 x86? ( https://releases.mattermost.com/desktop/3.5.0/mattermost-desktop-${PV}-linux-ia32.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/mattermost-desktop-${PV}"
QA_PREBUILT="opt/mattermost-desktop/mattermost-desktop
	opt/mattermost-desktop/libnode.so
	opt/mattermost-desktop/libffmpeg.so
"

src_install() {
	insinto /opt/mattermost-desktop/locales
	doins locales/*.pak

	insinto /opt/mattermost-desktop/resources
	doins resources/*.asar

	insinto /opt/mattermost-desktop
	doins *.pak
	doins *.bin
	doins *.dat

	exeinto /opt/mattermost-desktop

	doexe *.so
	doexe mattermost-desktop

	dosym /opt/mattermost-desktop/mattermost-desktop /opt/bin/mattermost-desktop

	newicon "${S}/icon.png" mattermost-desktop.png
	make_desktop_entry mattermost-desktop Mattermost mattermost-desktop
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
