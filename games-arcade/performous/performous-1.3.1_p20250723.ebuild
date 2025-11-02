# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

HASH_CED="28f46c18c60b851773b0ff61f3ce416fb09adcf3"
HASH_PERFORMOUS="43586b58c72e48b63974f418af07b85b1d366daa"

DESCRIPTION="SingStar GPL clone"
HOMEPAGE="https://performous.org/"
SRC_URI="
	https://github.com/performous/performous/archive/${HASH_PERFORMOUS}.tar.gz
		-> ${P}.tar.gz
	https://github.com/performous/compact_enc_det/archive/${HASH_CED}.tar.gz
		-> ${PN}-ced-${HASH_CED}.tar.gz
	songs? (
		https://downloads.sourceforge.net/project/performous/ultrastar-songs-jc/1/ultrastar-songs-jc-1.zip
		https://downloads.sourceforge.net/project/performous/ultrastar-songs-libre/3/ultrastar-songs-libre-3.zip
		https://downloads.sourceforge.net/project/performous/ultrastar-songs-restricted/3/ultrastar-songs-restricted-3.zip
		https://downloads.sourceforge.net/project/performous/ultrastar-songs-shearer/1/ultrastar-songs-shearer-1.zip
	)
"
S="${WORKDIR}/${PN}-${HASH_PERFORMOUS}"

LICENSE="
	GPL-2
	Apache-2.0 OFL-1.1
	songs? ( CC-BY-NC-SA-2.5 CC-BY-NC-ND-2.5 )
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="midi songs test webcam"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/libxmlpp:5.0
	dev-libs/boost:=[nls]
	dev-libs/glib:2
	dev-libs/icu:=
	dev-libs/libfmt:=
	gnome-base/librsvg:2
	media-libs/aubio:=[blas,fftw]
	media-libs/fontconfig:1.0
	media-libs/glm
	media-libs/libepoxy
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/portaudio[cxx]
	media-video/ffmpeg:=
	sys-libs/zlib
	virtual/libintl
	x11-libs/cairo
	x11-libs/pango
	midi? ( media-libs/portmidi )
	webcam? ( media-libs/opencv:= )
"
DEPEND="${RDEPEND}
	dev-cpp/nlohmann_json
	dev-libs/spdlog
	test? ( dev-cpp/gtest )
"
BDEPEND="
	sys-apps/help2man
	sys-devel/gettext
	virtual/pkgconfig
	songs? ( app-arch/unzip )
"

PATCHES=(
	# avoid compressed manpages (gzip)
	"${FILESDIR}"/${PN}-1.3.1-uncompressed_docs.patch
	# use cblas implementation instead of restricting to openblas
	"${FILESDIR}"/${PN}-1.3.1-cblas.patch
)

src_configure() {
	local mycmakeargs=(
		-DPERFORMOUS_VERSION=${PV}
		-DSHARE_INSTALL="${EPREFIX}"/usr/share/${PN}
		# it needs ON, not yes or something else
		-DBUILD_TESTS=$(usex test ON OFF)

		-DENABLE_MIDI=$(usex midi)
		-DENABLE_TOOLS=ON # no dep
		-DENABLE_WEBCAM=$(usex webcam)

		# avoid 3rd party libs
		-DSELF_BUILT_AUBIO=NEVER
		-DSELF_BUILT_JSON=NEVER
		-DSELF_BUILT_SPDLOG=NEVER

		# compact_enc_det is not in tree
		-DSELF_BUILT_CED=ALWAYS
		-DFETCHCONTENT_SOURCE_DIR_CED-SRC:PATH="${WORKDIR}/compact_enc_det-${HASH_CED}"

		# webserver needs unpackaged cpprestsdk which is not recommended for
		# use by its upstream (dead), may consider adding only if requested
		-DENABLE_WEBSERVER=no
	)
	cmake_src_configure
}

src_test() {
	# avoid overflow failures
	cmake_src_test -j1
}

src_install() {
	local DOCS=( README.md docs/{Authors,instruments}.txt )
	cmake_src_install

	insinto /usr/share/${PN}
	use songs && doins -r "${WORKDIR}"/songs
}
