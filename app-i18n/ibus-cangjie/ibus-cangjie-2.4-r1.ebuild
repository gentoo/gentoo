# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python3_6 )

inherit gnome2-utils python-r1

DESCRIPTION="Chinese Cangjie and Quick engines for IBus"
HOMEPAGE="http://cangjians.github.io/"
SRC_URI="https://github.com/Cangjians/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	app-i18n/libcangjie
	dev-python/cangjie[${PYTHON_USEDEP}]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/intltool
	nls? ( sys-devel/gettext )"

src_configure() {
	python_foreach_impl default
}

src_compile() {
	python_foreach_impl default
}

src_install() {
	python_foreach_impl default
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
