# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit gnome2-utils python-single-r1

DESCRIPTION="Japanese input method Anthy IMEngine for IBus Framework"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/ibus/ibus-anthy/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/anthy
	app-i18n/ibus[introspection]
	nls? ( virtual/libintl:0= )"

DEPEND="${RDEPEND}
	dev-libs/gobject-introspection
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_configure() {
	econf \
		--enable-private-png \
		$(use_enable nls)
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "app-dicts/kasumi is not required but probably useful for you."
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
