# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="A minimalistic plugin API for video effects"
HOMEPAGE="https://www.dyne.org/software/frei0r/"
SRC_URI="https://files.dyne.org/frei0r/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ppc ~ppc64 x86"
IUSE="doc +facedetect +scale0tilt"

RDEPEND="x11-libs/cairo[${MULTILIB_USEDEP}]
	facedetect? ( >=media-libs/opencv-2.3.0:=[${MULTILIB_USEDEP}] )
	scale0tilt? ( >=media-libs/gavl-1.2.0[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS.txt ChangeLog.txt README.txt TODO.txt )
PATCHES=( "${FILESDIR}/ocv4.patch" )

src_prepare() {
	cmake_src_prepare

	local f=CMakeLists.txt

	sed -i \
		-e '/set(CMAKE_C_FLAGS/d' \
		-e "/LIBDIR.*frei0r-1/s:lib:$(get_libdir):" \
		${f} || die

	# https://bugs.gentoo.org/418243
	sed -i \
		-e '/set.*CMAKE_C_FLAGS/s:"): ${CMAKE_C_FLAGS}&:' \
		src/filter/*/${f} || die
}

src_configure() {
	cmake-multilib_src_configure \
		"-DWITHOUT_OPENCV=$(usex !facedetect)" \
		"-DWITHOUT_GAVL=$(usex !scale0tilt)"
}

src_compile() {
	cmake-multilib_src_compile

	if use doc; then
		pushd doc
		doxygen || die
		popd
	fi
}

multilib_src_install_all() {
	use doc && dodoc -r doc/html
}
