# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib-minimal virtualx

DESCRIPTION="Helper library for RESTful services"
HOMEPAGE="https://wiki.gnome.org/Projects/Librest"

LICENSE="LGPL-2.1"
SLOT="0.7"
IUSE="+introspection test"
RESTRICT="!test? ( test )"
KEYWORDS="alpha amd64 ~arm arm64 hppa ~ia64 ~ppc ~ppc64 s390 sparc x86"

# Coverage testing should not be enabled
RDEPEND="
	app-misc/ca-certificates
	>=dev-libs/glib-2.24:2[${MULTILIB_USEDEP}]
	dev-libs/libxml2:2[${MULTILIB_USEDEP}]
	net-libs/libsoup:2.4[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.40
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( sys-apps/dbus[${MULTILIB_USEDEP}] )
"

multilib_src_configure() {
	# gnome support only adds dependency on obsolete libsoup-gnome
	# https://bugzilla.gnome.org/show_bug.cgi?id=758166
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-gcov \
		--without-gnome \
		--with-ca-certificates="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		$(multilib_native_use_enable introspection)

	if multilib_is_native_abi; then
		ln -s "${S}"/docs/reference/rest/html docs/reference/rest/html || die
	fi
}

multilib_src_test() {
	# Tests need dbus
	virtx emake check
}

multilib_src_compile() {
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}
