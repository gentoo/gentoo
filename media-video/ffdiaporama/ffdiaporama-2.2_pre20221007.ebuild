# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="cb0bb696bea9846fc63a43056c01ddc1efa4a2a8"

inherit qmake-utils xdg-utils

DESCRIPTION="Movie creator from photos and video clips"
HOMEPAGE="https://ffdiaporama.tuxfamily.org"
SRC_URI="https://github.com/laurantino/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openclipart"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtmultimedia:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	>=media-video/ffmpeg-4:0=[encode]
	openclipart? ( media-gfx/openclipart[svg,-gzip] )"
DEPEND="${RDEPEND}"

DOCS=( authors.txt )

S="${WORKDIR}/${PN}-${COMMIT}"

src_configure() {
	eqmake5 QMAKE_CFLAGS_ISYSTEM=
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	if use openclipart; then
		dosym ../../clipart/openclipart /usr/share/ffDiaporama/clipart/openclipart
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
