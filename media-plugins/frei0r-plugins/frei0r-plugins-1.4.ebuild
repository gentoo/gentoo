# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit cmake-utils multilib

DESCRIPTION="A minimalistic plugin API for video effects"
HOMEPAGE="http://www.dyne.org/software/frei0r/"
SRC_URI="http://files.dyne.org/frei0r/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc +facedetect +scale0tilt"

RDEPEND="x11-libs/cairo
	facedetect? ( >=media-libs/opencv-2.3.0 )
	scale0tilt? ( >=media-libs/gavl-1.2.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS ChangeLog README TODO )

src_prepare() {
	local f=CMakeLists.txt

	sed -i \
		-e '/set(CMAKE_C_FLAGS/d' \
		-e "/LIBDIR.*frei0r-1/s:lib:$(get_libdir):" \
		${f} || die

	# http://bugs.gentoo.org/418243
	sed -i \
		-e '/set.*CMAKE_C_FLAGS/s:"): ${CMAKE_C_FLAGS}&:' \
		src/filter/*/${f} || die
}

src_configure() {
	 local mycmakeargs=(
		$(cmake-utils_use "!facedetect" "WITHOUT_GAVL"  )
		$(cmake-utils_use "!scale0tilt" "WITHOUT_OPENCV")
	 )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc; then
		pushd doc
		doxygen || die
		popd
	fi
}

src_install() {
	cmake-utils_src_install

	use doc && dohtml -r doc/html
}
