# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION="0.44"
VALA_MAX_API_VERSION="0.50" # append versions in sed line if increased

COMMIT_ID=""

inherit cmake vala

DESCRIPTION="Presenter console with multi-monitor support for PDF files"
HOMEPAGE="https://pdfpc.github.io https://github.com/pdfpc/pdfpc"
LICENSE="GPL-3+"
SLOT="0"
IUSE="+gstreamer"
KEYWORDS="~amd64 ~x86"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN}/.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]]; then
		SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT_ID}"
	else
		SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	fi
fi

RDEPEND="
	app-text/discount
	app-text/poppler:=[cairo]
	dev-libs/glib:2
	dev-libs/json-glib
	dev-libs/libgee:0.8=
	gnome-base/librsvg
	net-libs/webkit-gtk:4=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-gtk:1.0=
		media-plugins/gst-plugins-cairo:1.0=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="$(vala_depend)"

DOCS=(
	CHANGELOG.rst
	FAQ.rst
	README.rst
	SUPPORT.rst
)

src_prepare() {
	cmake_src_prepare

	sed -i -e "s/valac/valac valac-0.50 valac-0.48 valac-0.46 valac-0.44/" cmake/vala/FindVala.cmake || die
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMOVIES=$(usex gstreamer on off)
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
	)
	cmake_src_configure
}
