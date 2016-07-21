# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=(be ca cs de en-GB en-US es-AR es-ES fi fr gl hu it ja lt nb-NO nl pl
pt-PT ru sk sv-SE tr uk zh-CN zh-TW)

MOZ_PV="${PV/_alpha/a}" # Handle alpha for SRC_URI
MOZ_PV="${MOZ_PV/_beta/b}" # Handle beta for SRC_URI
MOZ_PV="${MOZ_PV/_rc/rc}" # Handle rc for SRC_URI
MOZ_PN="${PN/-bin}"
MOZ_P="${MOZ_PN}-${MOZ_PV}"

MOZ_LANGPACK_PREFIX="${MOZ_PV}/langpack/${MOZ_P}."
MOZ_LANGPACK_SUFFIX=".langpack.xpi"

MOZ_HTTP_URI="http://archive.mozilla.org/pub/mozilla.org/${MOZ_PN}/releases"

inherit eutils multilib mozextension pax-utils nsplugins fdo-mime gnome2-utils mozlinguas

DESCRIPTION="Mozilla Application Suite - web browser, email, HTML editor, IRC"
SRC_URI="${SRC_URI}
	amd64? ( ${MOZ_HTTP_URI}/${MOZ_PV}/contrib/${MOZ_P}.en-US.linux-x86_64.tar.bz2 -> ${PN}_x86_64-${PV}.tar.bz2 )
	x86? ( ${MOZ_HTTP_URI}/${MOZ_PV}/linux-i686/en-US/${MOZ_P}.tar.bz2 -> ${PN}_i686-${PV}.tar.bz2 )"
HOMEPAGE="http://www.seamonkey-project.org/"
RESTRICT="strip mirror"

KEYWORDS="-* amd64 x86"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="startup-notification"

DEPEND="app-arch/unzip"
RDEPEND="dev-libs/atk
	>=sys-apps/dbus-0.60
	>=dev-libs/dbus-glib-0.72
	>=dev-libs/glib-2.26:2
	>=media-libs/alsa-lib-1.0.16
	gnome-base/gconf
	gnome-base/gnome-vfs
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-2.14:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	>=x11-libs/pango-1.22.0
	virtual/freedesktop-icon-theme
"

QA_PREBUILT="
	opt/${MOZ_PN}/*.so
	opt/${MOZ_PN}/${MOZ_PN}
	opt/${MOZ_PN}/${PN}
	opt/${MOZ_PN}/components/*.so
	opt/${MOZ_PN}/crashreporter
	opt/${MOZ_PN}/webapprt-stub
	opt/${MOZ_PN}/plugin-container
	opt/${MOZ_PN}/mozilla-xremote-client
	opt/${MOZ_PN}/updater
"

S="${WORKDIR}/${MOZ_PN}"

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack
}

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/seamonkey

	# Install seamonkey in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${D}${MOZILLA_FIVE_HOME}"

	# Install language packs
	mozlinguas_src_install

	# Create /usr/bin/seamonkey-bin
	dodir /usr/bin/
	cat <<EOF >"${D}"/usr/bin/seamonkey-bin
#!/bin/sh
unset LD_PRELOAD
exec /opt/seamonkey/seamonkey "\$@"
EOF
	fperms 0755 /usr/bin/seamonkey-bin

	# Install icon and .desktop for menu entry
	newicon "${D}${MOZILLA_FIVE_HOME}"/chrome/icons/default/default48.png ${PN}.png
	domenu "${FILESDIR}/icon/${PN}.desktop"

	if use startup-notification; then
	    echo "StartupNotify=true" >> "${D}"/usr/share/applications/${PN}.desktop
	fi

	# Fix prefs that make no sense for a system-wide install
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	doins "${FILESDIR}"/local-settings.js
	# Copy preferences file so we can do a simple rename.
	cp "${FILESDIR}"/all-gentoo-1-cve-2015-4000.js  "${D}"${MOZILLA_FIVE_HOME}/all-gentoo.js

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/10${PN} || die

	# Handle plugins dir through nsplugins.eclass
	share_plugins_dir

	# Required in order to use plugins and even run seamonkey on hardened.
	pax-mark mr "${ED}"/${MOZILLA_FIVE_HOME}/{seamonkey,seamonkey-bin,plugin-container}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	# Update mimedb for the new .desktop file
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
