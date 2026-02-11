# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="tk"

inherit meson python-r1 toolchain-funcs xdg

DESCRIPTION="A free astronomical image processing software"
HOMEPAGE="https://siril.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/free-astro/${PN}.git"
else
	SRC_URI="https://gitlab.com/free-astro/siril/-/archive/${PV/_/-}/${PN}-${PV/_/-}.tar.bz2"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

LICENSE="GPL-3+ Boost-1.0"
SLOT="0"
IUSE="curl exif ffmpeg git heif jpeg jpegxl openmp png raw tiff"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/yyjson-0.10.0:=
	media-libs/lcms:=
	media-libs/librtprocess
	>=media-libs/opencv-4.2.0:=[features2d]
	>=sci-astronomy/wcslib-7.12:=
	sci-libs/cfitsio:=
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22.0:3
	x11-libs/gtksourceview:4
	x11-libs/pango
	virtual/zlib:=
	curl? ( net-misc/curl )
	exif? ( >=media-gfx/exiv2-0.25:= )
	ffmpeg? ( media-video/ffmpeg:= )
	git? ( dev-libs/libgit2:= )
	heif? ( media-libs/libheif:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpegxl? ( media-libs/libjxl:= )
	png? ( >=media-libs/libpng-1.6.0:= )
	raw? ( media-libs/libraw:= )
	tiff? ( media-libs/tiff:= )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-build/cmake
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}/${PN}-1.4-docfiles.patch"
	"${FILESDIR}/${PN}-1.4.0-libgit2.patch"
	"${FILESDIR}/${PN}-1.4.0-libjpeg.patch"
	"${FILESDIR}/${PN}-1.4.0-libcurl.patch"
)

DOCS=( README.md ChangeLog AUTHORS )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local emesonargs=(
		-DlibXISF=false
		-Dffms2=false
		-Dcriterion=false
		$(meson_use curl libcurl)
		$(meson_use exif exiv2)
		$(meson_use ffmpeg)
		$(meson_use git libgit2)
		$(meson_use heif libheif)
		$(meson_use jpeg libjpeg)
		$(meson_use jpegxl libjxl)
		$(meson_use openmp)
		$(meson_use png libpng)
		$(meson_use raw libraw)
		$(meson_use tiff libtiff)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
