# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson vala

DESCRIPTION="glib library for communicating with snapd"
HOMEPAGE="https://snapcraft.io/"
SRC_URI="https://github.com/canonical/snapd-glib/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/1"
KEYWORDS="~amd64"

IUSE="doc introspection qml qt6 vala"
REQUIRED_USE="
	qml? ( qt6 )
	vala? ( introspection )
"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	qt6? ( dev-qt/qttools:6[linguist] )
"

DEPEND="
	dev-libs/json-glib
	dev-libs/glib:2
	dev-util/glib-utils
	net-libs/libsoup:3.0
	doc? (
		dev-build/gtk-doc-am
		dev-util/gi-docgen
		dev-util/gtk-doc
	)
	introspection? ( dev-libs/gobject-introspection )
	qml? (
		qt6? ( dev-qt/qtdeclarative:6 )
	)
	qt6? (
		dev-qt/qtbase:6[network,widgets]
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
		"$(meson_use qt6)"
		"$(meson_use vala vala-bindings)"
		-Dsoup2=false
		-Dqt5=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install
	if use doc; then
		dodir /usr/share/gtk-doc/html/
		mv "${ED}/usr/share/doc/${PN}" "${ED}/usr/share/gtk-doc/html/${PF}" || die
	fi
}
