# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# CED is only used in 1.2.0 and can be dropped on bump, no LICENSE
# changes needed given Apache-2.0 is also used by installed fonts
HASH_CED=9ca1351fe0b1e85992a407b0fc54a63e9b3adc6e

DESCRIPTION="SingStar GPL clone"
HOMEPAGE="https://performous.org/"
SRC_URI="
	https://github.com/performous/performous/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
	https://github.com/performous/compact_enc_det/archive/${HASH_CED}.tar.gz
		-> ${PN}-ced-${HASH_CED}.tar.gz
	songs? (
		mirror://sourceforge/performous/ultrastar-songs-jc-1.zip
		mirror://sourceforge/performous/ultrastar-songs-libre-3.zip
		mirror://sourceforge/performous/ultrastar-songs-restricted-3.zip
		mirror://sourceforge/performous/ultrastar-songs-shearer-1.zip
	)"

LICENSE="
	GPL-2
	Apache-2.0 OFL-1.1
	songs? ( CC-BY-NC-SA-2.5 CC-BY-NC-ND-2.5 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="midi songs webcam"

RDEPEND="
	dev-cpp/libxmlpp:5.0
	dev-libs/boost:=[nls]
	dev-libs/glib:2
	dev-libs/icu:=
	gnome-base/librsvg:2
	media-libs/aubio:=[fftw]
	media-libs/fontconfig:1.0
	media-libs/glm
	media-libs/libepoxy
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/portaudio
	media-video/ffmpeg:=
	virtual/libintl
	x11-libs/cairo
	x11-libs/pango
	midi? ( media-libs/portmidi )
	webcam? ( media-libs/opencv:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	sys-devel/gettext
	songs? ( app-arch/unzip )"

PATCHES=(
	"${FILESDIR}"/${P}-ffmpeg5.patch
)

src_prepare() {
	cmake_src_prepare

	if [[ -v LINGUAS ]]; then
		local po
		for po in lang/*.po; do
			: "${po#*/}"
			has "${_%.*}" ${LINGUAS} || rm "${po}" || die
		done
	fi

	# glibmm is only needed if libxmlpp:2.6, but :5.0 is used if available
	sed -i '/Glibmm/d' cmake/Modules/FindLibXML++.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_MIDI=$(usex midi)
		-DENABLE_WEBCAM=$(usex webcam)
		-DFETCHCONTENT_SOURCE_DIR_CED-SOURCES="${WORKDIR}"/compact_enc_det-${HASH_CED}
		-DSHARE_INSTALL="${EPREFIX}"/usr/share/${PN}

		# webserver needs unpackaged cpprestsdk which is not recommended for
		# use by its upstream (dead), may consider adding only if requested
		-DENABLE_WEBSERVER=no
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( README.md docs/{Authors,instruments}.txt )
	cmake_src_install

	insinto /usr/share/${PN}
	use songs && doins -r "${WORKDIR}"/songs

	gzip -d "${ED}"/usr/share/man/man6/${PN}.6.gz || die
}
