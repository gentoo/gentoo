# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.44"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1+ BSD-2 CC-BY-3.0 CC-BY-SA-3.0" # code is LGPL-2.1+, BSD-2 for bundled snowball-stemmer, CC licenses for some icons
SLOT="0"

IUSE="unwind +ytnef"

KEYWORDS="~amd64 ~x86"

# for now both enchants work
# FIXME: add valadoc support

DEPEND="
	>=dev-libs/appstream-glib-0.7.10
	>=dev-libs/glib-2.54:2
	>=gui-libs/libhandy-0.0.9:0.0=
	>=x11-libs/gtk+-3.22.26:3[introspection]
	>=net-libs/webkit-gtk-2.20:4=[introspection]
	app-text/gspell[vala]
	app-text/iso-codes
	>=dev-db/sqlite-3.12:3

	>=net-libs/libsoup-2.48:2.4[introspection]
	net-libs/gnome-online-accounts

	>=dev-libs/libgee-0.8.5:0.8=[introspection]
	>=x11-libs/libnotify-0.7.5[introspection]
	>=media-libs/libcanberra-0.28
	>=dev-libs/gmime-2.6.17:2.6
	>=app-crypt/libsecret-0.11[introspection,vala]
	>=dev-libs/libxml2-2.7.8:2
	>=app-crypt/gcr-3.10.1:0=[gtk,introspection,vala]
	app-text/enchant
	>=dev-libs/folks-0.11:0
	dev-libs/json-glib
	unwind? ( >=sys-libs/libunwind-1.1:7 )
	ytnef? ( >=net-mail/ytnef-1.9.3 )
"

BDEPEND="
	sys-devel/gettext
	dev-util/desktop-file-utils
	virtual/pkgconfig
	$(vala_depend)
"

RDEPEND="${DEPEND}
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
"

src_prepare() {
	local i
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd po ; echo *.po) ; do
			if ! has ${i%.po} ${LINGUAS} ; then
				sed -i -e "/^${i%.po}$/d" po/LINGUAS || die
			fi
		done
	fi

	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	# appstream_util & desktop_file_validate doesn't seem to
	# doing anything useful for an actual release, maybe for 9999?
	local emesonargs=(
		-Dlibunwind_optional=$(usex unwind false true)
		-Dtnef-support=$(usex ytnef true false)
		-Dpoodle=true
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
