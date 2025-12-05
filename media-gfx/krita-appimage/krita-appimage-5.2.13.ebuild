# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=krita
MY_P=${MY_PN}-${PV}
inherit desktop xdg

DESCRIPTION="Free digital painting application. Digital Painting, Creative Freedom!"
HOMEPAGE="https://apps.kde.org/krita/ https://krita.org/"
SRC_URI="amd64? ( mirror://kde/stable/${MY_PN}/${PV}/${MY_P}-x86_64.AppImage )"
S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="$(ver_cut 1-2)"
KEYWORDS="-* ~amd64"

RESTRICT="test strip"

RDEPEND="sys-fs/fuse:0"

QA_PREBUILT="opt/*"

src_unpack() { :; }

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /opt/${MY_PN}
	doins "${DISTDIR}"/${MY_P}-x86_64.AppImage

	chmod +x "${D}"/opt/${MY_PN}/${MY_P}-x86_64.AppImage

	make_desktop_entry "/opt/${MY_PN}/${MY_P}-x86_64.AppImage %F" "Krita ${PV} AppImage" \
		"" "Qt;KDE;Graphics;2DGraphics;RasterGraphics;"
}
