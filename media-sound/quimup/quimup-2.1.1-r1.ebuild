# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Qt client for the music player daemon (MPD)"
HOMEPAGE="https://quimup.sourceforge.io"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P^}.source.tar.gz
https://master.dl.sourceforge.net/project/${PN}/${PN^}%20${PV}/changelog -> ${P}-changelog
https://master.dl.sourceforge.net/project/${PN}/${PN^}%20${PV}/readme -> ${P}-readme"
S="${WORKDIR}/${P^}.source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	media-libs/libmpdclient
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( changelog faq readme )

src_prepare() {
	default
	# bug 947318
	local x
	for x in changelog readme; do
		rm ${x} || die
		cp "${DISTDIR}"/${P}-${x} ${x} || die
	done
}

src_configure() {
	eqmake6
}

src_install() {
	default
	dobin ${PN}

	for x in 32 64 128 scalable; do
		doicon -s ${x} RPM_DEB_build/share/icons/hicolor/${x}*/*
	done

	domenu RPM_DEB_build/share/applications/${PN^}.desktop
}
