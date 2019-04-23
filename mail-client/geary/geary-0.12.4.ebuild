# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.40"
# Keep cmake-utils at the end
inherit gnome2 vala cmake-utils

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1+ BSD-2 CC-BY-3.0 CC-BY-SA-3.0" # code is LGPL-2.1+, BSD-2 for bundled snowball-stemmer, CC licenses for some icons
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/glib-2.42:2
	>=x11-libs/gtk+-3.14.0:3[introspection]
	>=net-libs/webkit-gtk-2.10.0:4=[introspection]
	app-text/iso-codes
	>=dev-db/sqlite-3.12:3

	>=net-libs/libsoup-2.48:2.4[introspection]
	>=dev-libs/libgee-0.8.5:0.8=[introspection]
	>=x11-libs/libnotify-0.7.5[introspection]
	>=media-libs/libcanberra-0.28
	>=dev-libs/gmime-2.6.17:2.6
	>=app-crypt/libsecret-0.11[introspection,vala]
	>=dev-libs/libxml2-2.7.8:2
	>=app-crypt/gcr-3.10.1:0=[gtk,introspection,vala]
	>=app-text/enchant-1.6:0
"
RDEPEND="${DEPEND}
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
" # org.gnome.desktop.interface clock-format global setting usage
# gnome-doc-utils for xml2po for TRANSLATE_HELP option
DEPEND="${DEPEND}
	sys-devel/gettext
	dev-util/intltool
	app-text/gnome-doc-utils
	dev-util/desktop-file-utils
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	eapply "${FILESDIR}"/geary-0.12-libdir.patch
	eapply "${FILESDIR}"/geary-0.12-use-upstream-jsc.patch
	eapply "${FILESDIR}"/${PV}-fix-cancellable.patch
	# https://bugzilla.gnome.org/show_bug.cgi?id=751557
	sed -i -e 's/vapigen --library/${VAPIGEN} --library/' src/CMakeLists.txt || die

	local i
	if [[ -n "${LINGUAS+x}" ]] ; then
		for i in $(cd po ; echo *.po) ; do
			if ! has ${i%.po} ${LINGUAS} ; then
				sed -i -e "/^${i%.po}$/d" po/LINGUAS || die
			fi
		done
	fi

	cmake-utils_src_prepare
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DICON_UPDATE=OFF
		-DDESKTOP_UPDATE=OFF
		-DDESKTOP_VALIDATE=OFF
		-DTRANSLATE_HELP=ON

		-DNO_FATAL_WARNINGS=ON
		-DGSETTINGS_COMPILE=OFF
		-DVALA_EXECUTABLE="${VALAC}"
		-DVAPIGEN="${VAPIGEN}"
	)

	cmake-utils_src_configure
}
