# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg vala

DESCRIPTION="Manage your passwords and encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE="ldap zeroconf"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	>=dev-libs/glib-2.58:2
	>=app-crypt/gcr-3.11.91:=
	>=app-crypt/gpgme-1.7.0
	>=x11-libs/gtk+-3.22.0:3
	>=app-crypt/gnupg-2.0.12
	gui-libs/libhandy:1=
	>=app-crypt/libsecret-0.16
	dev-libs/libpwquality
	net-misc/openssh
	ldap? ( net-nds/openldap:= )
	>=net-libs/libsoup-2.33.92:2.4
	zeroconf? ( >=net-dns/avahi-0.6:=[dbus] )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/libxml2:2
	app-crypt/gcr[vala]
	app-crypt/libsecret[vala]
	gui-libs/libhandy:1[vala]
"
BDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/appstream-glib
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dhelp=true
		-Dpgp-support=true
		-Dcheck-compatible-gpg=false # keep lowest version listed as compatible as min dep for gnupg RDEPEND
		-Dpkcs11-support=true
		-Dkeyservers-support=true
		-Dhkp-support=true
		$(meson_use ldap ldap-support)
		$(meson_use zeroconf key-sharing)
		-Dmanpage=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
