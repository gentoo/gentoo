# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="A free astronomical image processing software"
HOMEPAGE="https://www.siril.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/free-astro/${PN}.git"
else
	SRC_URI="https://gitlab.com/free-astro/siril/-/archive/${PV/_/-}/${PN}-${PV/_/-}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="curl ffmpeg gnuplot heif jpeg openmp png raw tiff wcs"

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
	jpeg? ( virtual/jpeg )
	png? ( >=media-libs/libpng-1.6.0 )
	raw? ( media-libs/libraw )
	tiff? ( media-libs/tiff )
	wcs? ( >=sci-astronomy/wcslib-7.7 )
"
RDEPEND="
	${DEPEND}
	gnuplot? ( sci-visualization/gnuplot )
"

PATCHES=(
	"${FILESDIR}/${PN}-docfiles.patch"
)

DOCS=( README.md NEWS ChangeLog LICENSE.md LICENSE_sleef.txt AUTHORS )

pkg_pretend() {
	use openmp && tc-check-openmp
}

src_configure() {
	local emesonargs=(
		$(meson_use openmp)
		$(usex curl -Denable-libcurl=yes -Denable-libcurl=no)
	)
	meson_src_configure
}
