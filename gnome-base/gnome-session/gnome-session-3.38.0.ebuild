# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop gnome.org gnome2-utils meson xdg

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-session"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc elogind systemd"
# There is a null backend available, thus ?? not ^^
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=dev-libs/glib-2.46.0:2
	>=x11-libs/gtk+-3.22.0:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=gnome-base/gnome-desktop-3.34.2:3=
	>=dev-libs/json-glib-0.10
	media-libs/mesa[egl,gles2,X(+)]
	media-libs/libepoxy
	x11-libs/libXcomposite

	systemd? ( >=sys-apps/systemd-242:0= )
	elogind? ( >=sys-auth/elogind-239.4 )
"

# Pure-runtime deps from the session files should *NOT* be added here.
# >=gnome-settings-daemon-3.35.91 for UsbProtection required component.
# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# sys-apps/dbus[X] is needed for session management.
# Our 90-xcursor-theme-gnome reads a setting from gsettings-desktop-schemas.
RDEPEND="${DEPEND}
	>=gnome-base/gnome-settings-daemon-3.35.91
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	sys-apps/dbus[X]

	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
"
BDEPEND="
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	x11-libs/xtrans
	virtual/pkgconfig
	doc? ( app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2 )
"

PATCHES=(
	"${FILESDIR}"/${P}-meson-Support-elogind.patch
)

src_prepare() {
	xdg_src_prepare
	# Install USE=doc in $PF if enabled
	sed -i -e "s:meson\.project_name(), 'dbus':'${PF}', 'dbus':" doc/dbus/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddeprecation_flags=false
		$(meson_use elogind)
		-Dsession_selector=true # gnome-custom-session
		$(meson_use systemd)
		-Dsystemd_session=$(usex systemd default disable)
		$(meson_use systemd systemd_journal)
		$(meson_use doc docbook)
		-Dconsolekit=false
		-Dman=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	newmenu "${FILESDIR}/defaults.list-r5" gnome-mimeapps.list

	exeinto /etc/X11/xinit/xinitrc.d/
	newexe "${FILESDIR}/15-xdg-data-gnome-r1" 15-xdg-data-gnome

	# This should be done here as discussed in bug #270852
	newexe "${FILESDIR}/10-user-dirs-update-gnome-r1" 10-user-dirs-update-gnome

	# Set XCURSOR_THEME from current dconf setting instead of installing
	# default cursor symlink globally and affecting other DEs (bug #543488)
	# https://bugzilla.gnome.org/show_bug.cgi?id=711703
	newexe "${FILESDIR}/90-xcursor-theme-gnome" 90-xcursor-theme-gnome
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version gnome-base/gdm && ! has_version x11-misc/sddm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi

	if ! use systemd && ! use elogind; then
		ewarn "You are building without systemd or elogind support."
		ewarn "gnome-session won't be able to correctly track and manage your session."
	fi
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
