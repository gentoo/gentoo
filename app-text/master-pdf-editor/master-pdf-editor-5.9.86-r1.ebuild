# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
SRC_URI="https://code-industry.net/public/${P}-qt5.x86_64-qt_include.tar.gz"
S="${WORKDIR}/${PN}-${PV%%.*}"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	dev-libs/pkcs11-helper
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/freetype
	media-libs/libglvnd
	media-gfx/sane-backends
	sys-libs/glibc
	sys-libs/zlib
"

QA_PREBUILT="opt/${PN}/masterpdfeditor5"

src_install() {
	insinto /opt/${PN}
	doins -r fonts help iconengines imageformats lang platforms platformthemes stamps templates masterpdfeditor5.png
	exeinto /opt/${PN}
	doexe masterpdfeditor5 masterpdfeditor5.sh
	exeinto /opt/bin
	doexe "${FILESDIR}"/mpe5

	make_desktop_entry "mpe5 %f" \
		"Master PDF Editor ${PV}" /opt/${PN}/masterpdfeditor5.png \
		"Office;Graphics;Viewer" \
		"MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;\nTerminal=false"
}
