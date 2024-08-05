# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake gnome2 optfeature

DESCRIPTION="Evolution module for connecting to Microsoft Exchange Web Services"
HOMEPAGE="https://gitlab.gnome.org/GNOME/evolution/-/wikis/home https://gitlab.gnome.org/GNOME/evolution-ews"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="test"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.68:2
	>=dev-libs/libical-3.0.5:0=[glib]
	>=dev-libs/json-glib-1.0.4
	>=dev-libs/libmspack-0.4
	dev-libs/libxml2:2
	>=gnome-extra/evolution-data-server-${PV}:0=
	>=mail-client/evolution-${PV}:2.0
	>=net-libs/libsoup-3.0:3.0
	>=x11-libs/gtk+-3.10:3
"
DEPEND="${RDEPEND}
	test? ( >=net-libs/uhttpmock-0.9:1.0 )
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

# Unittests fail to find libevolution-ews.so
RESTRICT="test !test? ( test )"

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare
# call; if needed, set them after cmake_src_prepare call, if that works
src_prepare() {
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_MSPACK=ON
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_test() {
	cmake_src_test
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	optfeature "oauth support" "gnome-extra/evolution-data-server[oauth-gtk3]"
}
