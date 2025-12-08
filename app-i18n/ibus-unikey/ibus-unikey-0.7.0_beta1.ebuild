# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2-utils

DESCRIPTION="Vietnamese UniKey engine for IBus"
HOMEPAGE="https://github.com/vn-input/ibus-unikey"
SRC_URI="https://github.com/vn-input/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-i18n/ibus
	virtual/libintl
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${P}-cmake4.patch" ) # bug 957750, git master

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
	)
	cmake_src_configure
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
