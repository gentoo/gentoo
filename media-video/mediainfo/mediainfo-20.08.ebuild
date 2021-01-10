# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0"

inherit xdg-utils autotools wxwidgets

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="https://mediaarea.net/mediainfo/ https://github.com/MediaArea/MediaInfo"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="curl mms wxwidgets"

RDEPEND="sys-libs/zlib
	>=media-libs/libzen-0.4.37
	~media-libs/lib${P}[curl=,mms=]
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/MediaInfo

pkg_setup() {
	TARGETS="CLI"
	if use wxwidgets; then
		TARGETS+=" GUI"
		setup-wxwidgets
	fi
}

src_prepare() {
	default

	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		sed -i -e "s:-O2::" configure.ac || die
		eautoreconf
	done
}

src_configure() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		local args=""
		[[ ${target} == "GUI" ]] && args="--with-wxwidgets --with-wx-gui"
		econf ${args}
	done
}

src_compile() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		default
	done
}
src_install() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target} || die
		default
		dodoc "${S}"/History_${target}.txt
	done
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
