# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic optfeature toolchain-funcs

DESCRIPTION="Tail with multiple windows"
HOMEPAGE="http://www.vanheusden.com/multitail/"
SRC_URI="http://www.vanheusden.com/multitail/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug examples unicode"
RESTRICT="test" # bug 492270

RDEPEND="sys-libs/ncurses:=[unicode(+)?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-6.4.1-gentoo.patch )

src_prepare() {
	default

	sed \
		-e "/^DESTDIR/s:=.*$:=${EPREFIX}:g" \
		-i Makefile || die

	sed \
		-e "s:/usr/bin/xclip:${EPREFIX}/usr/bin/xclip:g" \
		-i xclip.c ${PN}.conf || die
}

src_configure() {
	tc-export CC PKG_CONFIG
	use debug && append-flags -D_DEBUG
}

src_compile() {
	emake UTF8_SUPPORT=$(usex unicode)
}

src_install() {
	dobin multitail

	insinto /etc
	doins multitail.conf

	DOCS=( readme.txt thanks.txt )
	HTML_DOCS=( manual.html )
	einstalldocs

	doman multitail.1

	if use examples; then
		docinto examples
		dodoc conversion-scripts/colors-example.{pl,sh} conversion-scripts/convert-{geoip,simple}.pl
	fi
}

pkg_postinst() {
	optfeature "send a buffer to the X clipboard" x11-misc/xclip
}
