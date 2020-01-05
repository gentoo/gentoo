# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit gnome2-utils python-single-r1

DESCRIPTION="Japanese Anthy engine for IBus"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://github.com/ibus/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/anthy
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default
	gnome2_environment_reset
}

src_configure() {
	econf \
		$(use_enable nls) \
		--enable-private-png \
		--with-layout=default \
		--with-python=${EPYTHON}
}

src_test() {
	:
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die

	python_optimize
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! has_version app-dicts/kasumi; then
		elog "app-dicts/kasumi is not required but probably useful for you."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
