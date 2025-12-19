# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature

DESCRIPTION="Tail with multiple windows"
HOMEPAGE="http://www.vanheusden.com/multitail/ https://github.com/folkertvanheusden/multitail/"
SRC_URI="https://github.com/folkertvanheusden/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 ~sparc x86"
IUSE="debug examples unicode"

RDEPEND="sys-libs/ncurses:=[unicode(+)?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.0-gentoo.patch
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
	rm -rf "${ED}"/usr/share/doc/multitail-VERSION=${PV} || die

	local DOCS=( readme.txt thanks.txt )
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
