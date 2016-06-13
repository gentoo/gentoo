# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER="3.0"

inherit eutils autotools wxwidgets multilib

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediaarea.net/mediainfo/"
SRC_URI="http://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl mms wxwidgets"

RDEPEND="sys-libs/zlib
	media-libs/libzen
	~media-libs/lib${P}[curl=,mms=]
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/MediaInfo

pkg_setup() {
	TARGETS="CLI"
	use wxwidgets && TARGETS+=" GUI"
}

src_prepare() {
	epatch_user

	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target}
		sed -i -e "s:-O2::" configure.ac
		eautoreconf
	done
}

src_configure() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target}
		local args=""
		[[ ${target} == "GUI" ]] && args="--with-wxwidgets --with-wx-gui"
		econf ${args}
	done
}

src_compile() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target}
		default
	done
}
src_install() {
	local target
	for target in ${TARGETS}; do
		cd "${S}"/Project/GNU/${target}
		default
		dodoc "${S}"/History_${target}.txt
		if [[ ${target} == "GUI" ]]; then
			newicon "${S}"/Source/Resource/Image/MediaInfo.png ${PN}.png
			make_desktop_entry ${PN}-gui MediaInfo ${PN} "AudioVideo;GTK"
		fi
	done
}
