# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="A GTK+ graphical interactive version of nec2c"
HOMEPAGE="https://www.qsl.net/5b4az/pages/nec2.html"
SRC_URI="https://www.qsl.net/5b4az/pkg/nec2/xnec2c/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_install() {
	default
	rm -R "${D}/usr/share/doc/${PN}" || die

	docompress -x /usr/share/man
	dodoc AUTHORS README doc/*.txt
	use doc && dodoc -r doc/*.html doc/images
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
