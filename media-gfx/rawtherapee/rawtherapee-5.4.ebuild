# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils toolchain-funcs flag-o-matic gnome2-utils xdg-utils

MY_P=${P/_rc/-rc}
DESCRIPTION="A powerful cross-platform raw image processing program"
HOMEPAGE="http://www.rawtherapee.com/"
SRC_URI="http://rawtherapee.com/shared/source/${MY_P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="openmp"

RDEPEND="x11-libs/gtk+:3
	dev-libs/expat
	dev-libs/libsigc++:2
	media-libs/libcanberra[gtk3]
	media-libs/tiff:0
	media-libs/libpng:0
	media-libs/libiptcdata
	media-libs/lcms:2
	media-libs/lensfun
	sci-libs/fftw:3.0
	sys-libs/zlib
	virtual/jpeg:0"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
	dev-cpp/gtkmm:3.0"

S="${WORKDIR}/${MY_P}"

pkg_pretend() {
	if use openmp ; then
		tc-has-openmp || die "Please switch to an openmp compatible compiler"
	fi
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
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
