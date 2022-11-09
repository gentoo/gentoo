# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature toolchain-funcs xdg

DESCRIPTION="A free astronomical image processing software"
HOMEPAGE="https://www.siril.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/free-astro/${PN}.git"
else
	SRC_URI="https://gitlab.com/free-astro/siril/-/archive/${PV/_/-}/${PN}-${PV/_/-}.tar.bz2"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

LICENSE="GPL-3+ Boost-1.0"
SLOT="0"
IUSE="curl ffmpeg heif jpeg openmp png raw tiff wcs"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/json-glib-1.2.6
	>=dev-libs/libconfig-1.4[cxx]
	>=media-gfx/exiv2-0.25
	media-libs/librtprocess:=
	>=media-libs/opencv-4.4.0:=
	sci-libs/cfitsio
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	x11-libs/cairo
	>=x11-libs/gtk+-3.20.0:3
	curl? ( net-misc/curl )
	ffmpeg? ( media-video/ffmpeg:= )
	heif? ( media-libs/libheif )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( >=media-libs/libpng-1.6.0 )
	raw? ( media-libs/libraw )
	tiff? ( media-libs/tiff )
	wcs? ( >=sci-astronomy/wcslib-7.7 )
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-docfiles.patch"
	"${FILESDIR}/${PN}-$(ver_cut 1-2)-dependencies.patch"
)

DOCS=( README.md NEWS ChangeLog AUTHORS )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local emesonargs=(
		-Dffms2=false
		-Dcriterion=false
		$(meson_use ffmpeg)
		$(meson_use heif libheif)
		$(meson_use jpeg libjpeg)
		$(meson_use openmp)
		$(meson_use png libpng)
		$(meson_use raw libraw)
		$(meson_use tiff libtiff)
		$(meson_use wcs wcslib)
		$(usex curl -Denable-libcurl=yes -Denable-libcurl=no)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	optfeature "gnuplot support" sci-visualization/gnuplot
}
