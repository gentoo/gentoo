# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Tail with multiple windows"
HOMEPAGE="http://www.vanheusden.com/multitail/"
SRC_URI="http://www.vanheusden.com/multitail/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ~ia64 ppc ~sparc x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE="debug examples unicode"

RDEPEND="
	sys-libs/ncurses:0=[unicode?]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"
RESTRICT="test" # bug #492270

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-6.4.1-gentoo.patch

	sed \
		-e "/^DESTDIR/s:=.*$:=${EROOT}:g" \
		-i Makefile || die

	sed \
		-e "s:/usr/bin/xclip:${EPREFIX}/usr/bin/xclip:g" \
		-i xclip.c ${PN}.conf || die

	tc-export CC PKG_CONFIG

	use debug && append-flags "-D_DEBUG"
}

src_compile() {
	emake UTF8_SUPPORT=$(usex unicode)
}

src_install () {
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
