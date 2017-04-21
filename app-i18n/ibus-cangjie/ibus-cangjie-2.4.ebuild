# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_{4,5,6} )

inherit autotools-utils gnome2-utils python-r1 eutils

DESCRIPTION="The IBus engine for users of the Cangjie and Quick input methods"
HOMEPAGE="http://cangjians.github.io"
SRC_URI="https://github.com/Cangjians/ibus-cangjie/releases/download/v${PV}/ibus-cangjie-${PV}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=app-i18n/ibus-1.4.1
	app-i18n/libcangjie
	dev-python/cangjie[${PYTHON_USEDEP}]
	dev-util/intltool
	sys-devel/gettext"

RDEPEND=">=app-i18n/ibus-1.4.1
	app-i18n/libcangjie
	dev-python/cangjie[${PYTHON_USEDEP}]
	virtual/libintl
	${PYTHON_DEPS}"

src_configure() {
	python_foreach_impl autotools-utils_src_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile
}

src_install() {
	python_foreach_impl autotools-utils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}
