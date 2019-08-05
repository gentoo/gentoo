# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Scans your music files and tags them with loudness information"
HOMEPAGE="https://github.com/jiixyj/loudness-scanner/"
SRC_URI="https://dev.gentoo.org/~tamiko/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg gtk mpg123 musepack qt5 sndfile"
REQUIRED_USE="|| ( sndfile ffmpeg mpg123 musepack )"

DEPEND="
	dev-libs/glib
	media-libs/libebur128
	media-libs/taglib
	ffmpeg? ( media-video/ffmpeg )
	mpg123? ( media-sound/mpg123 )
	musepack? ( media-sound/musepack-tools )
	sndfile? ( media-libs/libsndfile )
	gtk? (
		gnome-base/librsvg:2
		x11-libs/cairo
		x11-libs/gtk+:2
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e 's|".",|"'${EROOT}'/usr/'$(get_libdir)'/loudness-scanner",|g' \
		"${S}"/scanner/inputaudio/input.c
}

src_configure() {
	local -a mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_SHARED_LIBS:BOOL=OFF # use static internal libraries
		-DDISABLE_FFMPEG:BOOL=$(usex ffmpeg no yes)
		-DDISABLE_GSTREAMER:BOOL=ON # depends on obsolete gstreamer-0.10
		-DDISABLE_GTK2:BOOL=$(usex gtk no yes)
		-DDISABLE_MPCDEC:BOOL=$(usex musepack no yes)
		-DDISABLE_MPG123:BOOL=$(usex mpg123 no yes)
		-DDISABLE_QT4:BOOL=ON
		-DDISABLE_QT5:BOOL=$(usex qt5 no yes)
		-DDISABLE_RSVG2:BOOL=$(usex gtk no yes)
		-DDISABLE_SNDFILE:BOOL=$(usex sndfile no yes)
	)
	cmake-utils_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/loudness
	use gtk && dobin "${BUILD_DIR}"/loudness-drop-gtk
	use qt5 && dobin "${BUILD_DIR}"/loudness-drop-qt5

	insinto /usr/$(get_libdir)/loudness-scanner
	doins "${BUILD_DIR}"/libinput_*.so

	einstalldocs
}
