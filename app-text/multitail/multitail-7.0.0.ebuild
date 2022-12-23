# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="Tail with multiple windows"
HOMEPAGE="http://www.vanheusden.com/multitail/ https://github.com/folkertvanheusden/multitail/"
SRC_URI="https://github.com/folkertvanheusden/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug examples unicode"

RDEPEND="sys-libs/ncurses:=[unicode(+)?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.0-gentoo.patch
	"${FILESDIR}"/${PN}-7.0.0-fix-clang16-build.patch
	"${FILESDIR}"/${PN}-7.0.0-fix-lto-type-mismatch.patch
)

src_prepare() {
	cmake_src_prepare
	# cmake looks for licence.txt to install it, which does not exist in the package
	cp LICENSE license.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUTF8_SUPPORT=$(usex unicode)
	)
	CMAKE_BUILD_TYPE=$(usex debug Debug)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /etc
	doins multitail.conf

	rm -rf "${ED}"/usr/{ect,etc} || die
	rm -rf "${ED}"/usr/share/doc/multitail-VERSION=6.4.3 || die

	DOCS=( readme.txt thanks.txt )
	HTML_DOCS=( manual.html )
	einstalldocs

	if use examples; then
		docinto examples
		dodoc conversion-scripts/colors-example.{pl,sh} conversion-scripts/convert-{geoip,simple}.pl
	fi
}

pkg_postinst() {
	optfeature "send a buffer to the X clipboard" x11-misc/xclip
}
