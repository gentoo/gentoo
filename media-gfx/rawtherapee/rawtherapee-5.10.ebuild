# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/_rc/-rc}
inherit cmake flag-o-matic toolchain-funcs xdg-utils

DESCRIPTION="A powerful cross-platform raw image processing program"
HOMEPAGE="https://www.rawtherapee.com/"
SRC_URI="https://rawtherapee.com/shared/source/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="openmp tcmalloc"

RDEPEND="
	dev-cpp/atkmm:0
	dev-cpp/cairomm:0
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-cpp/pangomm:1.4
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libsigc++:2
	gnome-base/librsvg:2
	media-gfx/exiv2:=
	media-libs/lcms:2
	media-libs/lensfun
	media-libs/libcanberra[gtk3]
	media-libs/libiptcdata
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/tiff:=
	sci-libs/fftw:3.0=
	sys-libs/zlib
	x11-libs/gtk+:3
	tcmalloc? ( dev-util/google-perftools )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	# upstream tested that "fast-math" give wrong results, so filter it
	# https://bugs.gentoo.org/show_bug.cgi?id=606896#c2
	filter-flags -ffast-math
	# -Ofast enable "fast-math" both in gcc and clang
	replace-flags -Ofast -O3
	# In case we add an ebuild for klt we can (i)use that one,
	# see http://cecas.clemson.edu/~stb/klt/
	local mycmakeargs=(
		-DOPTION_OMP=$(usex openmp)
		-DDOCDIR=/usr/share/doc/${PF}
		-DCREDITSDIR=/usr/share/${PN}
		-DLICENCEDIR=/usr/share/${PN}
		-DCACHE_NAME_SUFFIX=""
		-DWITH_SYSTEM_KLT="off"
		-DENABLE_TCMALLOC=$(usex tcmalloc)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
