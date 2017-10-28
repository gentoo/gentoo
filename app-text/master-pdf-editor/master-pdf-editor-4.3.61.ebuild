# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils eutils versionator

DESCRIPTION="Master PDF Editor is a complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"

SRC_URI="http://get.code-industry.net/public/${P}_qt5.amd64.tar.gz"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

COMMON_DEPEND="
	app-arch/bzip2
	dev-libs/double-conversion
	dev-libs/glib
	dev-libs/icu
	dev-libs/openssl
	media-gfx/graphite2
	media-gfx/sane-backends
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/tiff
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	>=dev-qt/qtsvg-5.4:5
	>=dev-qt/qtnetwork-5.4:5
	>=dev-qt/qtgui-5.4:5
	>=dev-qt/qtprintsupport-5.4:5
"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-$(get_major_version ${PV})"

src_install() {
	local dest=/opt/${PN}
	local bin_name=masterpdfeditor4

	insinto ${dest}
	doins -r fonts lang stamps templates ${bin_name}.png

	exeinto ${dest}
	doexe ${bin_name}

	dosym ${dest}/${bin_name} /opt/bin/${bin_name}
	make_desktop_entry ${bin_name} \
		"Master PDF Editor ${PV}" ${dest}/${bin_name}.png \
		"Office;Graphics;Viewer" \
		"MimeType=application/pdf;application/x-bzpdf;application/x-gzpdf;\nTerminal=false"
}

pkg_postinst() {
	sed -i -e \
		'/^Exec=/s/masterpdfeditor4/masterpdfeditor4 %f/' \
		/usr/share/applications/masterpdfeditor4-${PN}.desktop || die
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
