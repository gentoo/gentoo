# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg-utils

DESCRIPTION="Qt6 client for the music player daemon (MPD)"
HOMEPAGE="https://sourceforge.net/projects/quimup/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${PN^}-${PV}.source.tar.gz"
S="${WORKDIR}/${PN^}-${PV}.source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( changelog faq readme )

src_configure() {
	eqmake6
}

src_install() {
	default
	dobin ${PN}
	local i
	for i in 32x32 64x64 128x128; do
		doicon -s ${i} RPM_DEB_build/share/icons/hicolor/${i}/apps/quimup.png
	done
	domenu RPM_DEB_build/share/applications/Quimup.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
