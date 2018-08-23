# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson xdg-utils

DESCRIPTION="Enlightenment window manager"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0.17/${PV%%_*}"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"

E_CONF_MODS=(
	applications bindings dialogs display
	interaction intl menus paths
	performance randr shelves theme
	window-manipulation window-remembers
)

E_NORM_MODS=(
	appmenu backlight battery bluez4
	clock conf cpufreq everything
	fileman fileman-opinfo gadman geolocation
	ibar ibox lokker luncher
	mixer msgbus music-control notification
	packagekit pager pager-plain quickaccess
	shot start syscon sysinfo
	systray tasks teamwork temperature
	tiling time vkbd winlist
	wireless wizard wl-buffer wl-desktop-shell
	wl-drm wl-text-input wl-weekeyboard wl-wl
	wl-x11 xkbswitch xwayland
)

IUSE_E_MODULES=(
	${E_CONF_MODS[@]/#/enlightenment_modules_conf-}
	${E_NORM_MODS[@]/#/enlightenment_modules_}
)

IUSE="acpi connman doc nls pam systemd udisks wayland ${IUSE_E_MODULES[@]/#/+}"

RDEPEND="
	>=dev-libs/efl-1.20.5[eet,X]
	virtual/udev
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	connman? ( net-misc/connman )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		=dev-libs/efl-1.20*[drm,wayland]
		>=dev-libs/wayland-1.12.0
		x11-libs/libxkbcommon
		x11-libs/pixman
	)
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	xdg_environment_reset

	sed -i 's/Categories=Audio/Categories=AudioVideo/g' src/modules/mixer/emixer.desktop || die
}

src_configure() {
	local emesonargs=(
		-D device-udev=true
		-D install-sysactions=false
		-D mount-udisks=$(usex udisks true false)
		-D connman=$(usex connman true false)
		-D nls=$(usex nls true false)
		-D pam=$(usex pam true false)
		-D systemd=$(usex systemd true false)
		-D wayland=$(usex wayland true false)
	)

	local u c
	for u in ${IUSE_E_MODULES[@]} ; do
		c=${u#enlightenment_modules_}

		case ${c} in
		wl-*|xwayland)
			if ! use wayland ; then
				emesonargs+=( -D ${c}=false )
				continue
			fi

		;;
		esac

		emesonargs+=( -D ${c}=$(usex ${u} true false) )

	done

	meson_src_configure
}

src_install() {
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf

	if use doc ; then
		local HTML_DOCS=( doc/. )
	fi

	meson_src_install
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
