# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala

DESCRIPTION="glib library for communicating with snapd"
HOMEPAGE="https://snapcraft.io/"
SRC_URI="https://github.com/snapcore/snapd-glib/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="~amd64"

IUSE="doc introspection qml qt5 vala"
REQUIRED_USE="
	qml? ( qt5 )
	vala? ( introspection )
"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	qt5? ( dev-qt/linguist-tools:5 )
"

DEPEND="
	dev-libs/json-glib
	dev-libs/glib:2
	dev-util/glib-utils
	net-libs/libsoup:3.0
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
	qml? ( dev-qt/qtdeclarative:5 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		)
	vala? ( $(vala_depend) )
"

RDEPEND="${DEPEND}
	app-containers/snapd
"

pkg_setup() {
	vala_setup
}

src_configure() {
	local emesonargs=(
		"$(meson_use doc docs)"
		"$(meson_use introspection)"
		"$(meson_use qml qml-bindings)"
		"$(meson_use qt5 qt-bindings)"
		"$(meson_use vala vala-bindings)"
		-Dsoup2=false
	)

	meson_src_configure
}
