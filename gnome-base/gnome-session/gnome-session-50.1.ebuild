# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop gnome.org gnome2-utils meson systemd xdg

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-session"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc elogind systemd"

REQUIRED_USE="^^ ( elogind systemd )"

COMMON_DEPEND="
	>=dev-libs/glib-2.82.0:2
	gnome-base/gnome-desktop:4
	systemd? ( >=sys-apps/systemd-242:0= )
	elogind? ( >=sys-auth/elogind-242 )
"

# Pure-runtime deps from the session files should *NOT* be added here.
# >=gnome-settings-daemon-3.35.91 for UsbProtection required component.
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-settings-daemon-3.35.91
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	sys-apps/dbus[elogind=,systemd=]

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
	"${FILESDIR}"/${PN}-50.1-Make-systemd-optional.patch
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
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	newmenu "${FILESDIR}/defaults.list-r7" gnome-mimeapps.list
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
