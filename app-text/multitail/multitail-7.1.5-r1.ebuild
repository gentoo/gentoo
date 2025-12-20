# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="Tail with multiple windows"
HOMEPAGE="https://www.vanheusden.com/multitail/ https://github.com/folkertvanheusden/multitail/"
SRC_URI="https://github.com/folkertvanheusden/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE="debug examples unicode"

RDEPEND="sys-libs/ncurses:=[unicode(+)?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.0-gentoo.patch
	"${FILESDIR}"/${PN}-7.1.5-ncurses.patch
	"${FILESDIR}"/${PN}-7.1.5-cmake-gnuinstalldirs.patch
)

src_prepare() {
	# Don't clobber toolchain defaults
	sed -i -e '/-D_FORTIFY_SOURCE=2/d' CMakeLists.txt || die

	cmake_src_prepare

	# cmake looks for licence.txt to install it, which does not exist in the package
	cp LICENSE license.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DUSE_CPPCHECK=OFF
		-DUTF8_SUPPORT=$(usex unicode)
	)
	CMAKE_BUILD_TYPE=$(usex debug Debug)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	local DOCS=( README.md thanks.txt )
	local HTML_DOCS=( manual.html )
	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples
		dodoc conversion-scripts/{colors-example.{pl,sh},convert-{geoip,simple}.pl}
	fi
}

pkg_postinst() {
	optfeature "send a buffer to the X clipboard" x11-misc/xclip
}
