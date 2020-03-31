# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson vala xdg-utils

DESCRIPTION="Library and tool for reading and writing Jcat files "
HOMEPAGE="https://github.com/hughsie/libjcat"
SRC_URI="https://github.com/hughsie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gpg gtk-doc +introspection +man pkcs7 test"

RDEPEND="dev-libs/glib:2
	dev-libs/json-glib:=
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	introspection? ( dev-libs/gobject-introspection:= )
	pkcs7? ( net-libs/gnutls )
	dev-lang/vala:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	man? ( sys-apps/help2man )
	test? ( net-libs/gnutls[tools] )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.0-disable_installed_tests.patch
	"${FILESDIR}"/${PN}-0.1.0-use_right_python.patch
)

src_prepare() {
	xdg_environment_reset
# TODO: make vala optional
	vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtkdoc)
		$(meson_use gpg)
		$(meson_use introspection)
		$(meson_use man)
		$(meson_use pkcs7)
		$(meson_use test tests)
	)
	meson_src_configure
}
