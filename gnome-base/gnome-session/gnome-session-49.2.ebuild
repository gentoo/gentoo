# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-session"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc elogind systemd X"

REQUIRED_USE="^^ ( elogind systemd )"

COMMON_DEPEND="
	>=dev-libs/glib-2.82.0:2
	gui-libs/gtk:4[X?]
	gnome-base/gnome-desktop:4
	systemd? ( >=sys-apps/systemd-242:0= )
	elogind? ( >=sys-auth/elogind-242 )
"

# Pure-runtime deps from the session files should *NOT* be added here.
# >=gnome-settings-daemon-3.35.91 for UsbProtection required component.
# x11-misc/xdg-user-dirs{,-gtk} are needed to create the various XDG_*_DIRs, and
# create .config/user-dirs.dirs which is read by glib to get G_USER_DIRECTORY_*
# xdg-user-dirs-update is run during login (see 10-user-dirs-update-gnome below).
# sys-apps/dbus[X?] is needed for session management.
# Our 90-xcursor-theme-gnome reads a setting from gsettings-desktop-schemas.
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-settings-daemon-3.35.91
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	sys-apps/dbus[elogind=,systemd=,X?]

	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
	!systemd? ( >=gnome-base/gnome-session-openrc-$(ver_cut 1) )
"
DEPEND="${COMMON_DEPEND}"
BDEPEND="
	dev-libs/libxslt
	>=dev-util/gdbus-codegen-2.80.5-r1
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-49.2-Make-systemd-optional.patch
)

src_prepare() {
	default
	xdg_environment_reset

	# Install USE=doc in ${PF} if enabled
	sed -i -e "s:meson\.project_name()$:'${PF}':" doc/meson.build || die "Couldn't apply meson doc installation sed"
}

src_configure() {
	local emesonargs=(
		-Ddeprecation_flags=false
		$(meson_use doc docbook)
		-Dman=true
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use systemd systemd)
		$(meson_use X x11)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Gnome"

	newmenu "${FILESDIR}/defaults.list-r7" gnome-mimeapps.list

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
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
