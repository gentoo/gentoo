# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2

DESCRIPTION="Evolution module for connecting to Microsoft Exchange Web Services"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${P}-certificate-validation.patch.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.46:2
	dev-libs/libical:0=
	>=dev-libs/libmspack-0.4
	dev-libs/libxml2:2
	>=gnome-extra/evolution-data-server-${PV}-r1:0=
	>=mail-client/evolution-${PV}:2.0
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/gtk+-3.10:3
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	test? ( net-libs/uhttpmock )
"

# Unittests fail to find libevolution-ews.so
RESTRICT="test !test? ( test )"

# global scope PATCHES or DOCS array mustn't be used due to double default_src_prepare
# call; if needed, set them after cmake-utils_src_prepare call, if that works
src_prepare() {
	eapply "${WORKDIR}"/${P}-certificate-validation.patch # requires patch added in eds 3.30.5-r1
	cmake-utils_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_MSPACK=ON
		-DENABLE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}
