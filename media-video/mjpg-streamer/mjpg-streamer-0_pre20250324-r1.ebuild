# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="MJPG-streamer takes JPGs from Linux-UVC compatible webcams"
HOMEPAGE="https://github.com/jacksonliam/mjpg-streamer"
COMMIT="310b29f4a94c46652b20c4b7b6e5cf24e532af39"
SRC_URI="https://github.com/jacksonliam/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"
CMAKE_USE_DIR="${S}/${PN}-experimental"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

INPUT_PLUGINS="input-testpicture input-control input-file input-uvc input-http input-ptp2"
OUTPUT_PLUGINS="output-file output-udp output-http output-autofocus output-rtsp output-viewer output-zmqserver"
IUSE_PLUGINS="${INPUT_PLUGINS} ${OUTPUT_PLUGINS}"
IUSE="input-testpicture input-control +input-file input-uvc input-http input-ptp2
	output-file	output-udp +output-http output-autofocus output-rtsp output-viewer output-zmqserver
	www http-management wxp-compat"
REQUIRED_USE="|| ( ${INPUT_PLUGINS} )
	|| ( ${OUTPUT_PLUGINS} )"

RDEPEND="media-libs/libjpeg-turbo:=
	input-uvc? ( media-libs/libv4l acct-group/video )
	input-ptp2? ( media-libs/libgphoto2 )
	output-zmqserver? (
		dev-libs/protobuf-c
		net-libs/zeromq
	)"
DEPEND="${RDEPEND}
	input-testpicture? ( media-gfx/imagemagick )"

DOCS=( README.md TODO )

PATCHES=(
	"${FILESDIR}/${PN}-0_pre20250324-cmake4.patch" # downstream patch
	"${FILESDIR}/${PN}-0_pre20250324-norpath.patch" # downstream patch
)

src_prepare() {
	pushd "${CMAKE_USE_DIR}" || die
	local flag
	for flag in ${IUSE_PLUGINS}; do
		use ${flag} || cmake_comment_add_subdirectory plugins/${flag/put-/put_}
	done
	popd || die

	sed -e "s|@LIBDIR@|$(get_libdir)/${PN}/$(get_libdir)|g" \
		"${FILESDIR}/${PN}.initd" > "${S}/${PN}.initd" || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWXP_COMPAT=$(usex wxp-compat ON OFF)
		-DENABLE_HTTP_MANAGEMENT=$(usex http-management ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	use www || rm -rf "${ED}/usr/share/${PN}" || die

	newinitd "${S}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${CMAKE_USE_DIR}/mjpg_streamer@.service"
}

pkg_postinst() {
	einfo "Remember to set an input and output plugin for mjpg-streamer."

	if use input-uvc ; then
		einfo "To use the UVC plugin as a regular user, you must be a part of the video group"
	fi

	if use www ; then
		einfo "An example webinterface has been installed into"
		einfo "/usr/share/mjpg-streamer/www for your usage."
	fi
}
