# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit xdg-utils

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
	ibar ibox lokker mixer
	msgbus music-control notification packagekit
	pager pager-plain quickaccess shot
	start syscon systray tasks
	teamwork temperature tiling time
	winlist wireless wizard wl-desktop-shell
	wl-drm wl-text-input wl-weekeyboard wl-wl
	wl-x11 xkbswitch xwayland
)

IUSE_E_MODULES=(
	${E_CONF_MODS[@]/#/enlightenment_modules_conf-}
	${E_NORM_MODS[@]/#/enlightenment_modules_}
)

IUSE="acpi connman doc egl nls pam static-libs systemd udisks wayland ${IUSE_E_MODULES[@]/#/+}"

RDEPEND="
	>=dev-libs/efl-1.20.0[eet,X]
	virtual/udev
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/xcb-util-keysyms
	x11-misc/xkeyboard-config
	acpi? ( sys-power/acpid )
	connman? ( net-misc/connman )
	egl? ( =dev-libs/efl-1.20*[egl,wayland] )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	udisks? ( sys-fs/udisks:2 )
	wayland? (
		=dev-libs/efl-1.20*[drm,wayland]
		>=dev-libs/wayland-1.11.0
		x11-libs/libxkbcommon
		x11-libs/pixman
	)
"
DEPEND="
	${RDEPEND}
	sys-devel/automake:1.15
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	eapply "${FILESDIR}"/"${P}"-quickstart.diff

	xdg_environment_reset

	sed -i 's/Categories=Audio/Categories=AudioVideo/g' src/modules/mixer/emixer.desktop || die
}

src_configure() {
	local myconf=(
		--disable-install-sysactions
		--disable-policy-mobile
		--enable-device-udev
		$(use_enable connman)
		$(use_enable egl wayland-egl)
		$(use_enable nls)
		$(use_enable pam)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable udisks mount-udisks)
		$(use_enable wayland)
	)

	local u c
	for u in ${IUSE_E_MODULES[@]} ; do
		c=${u#enlightenment_modules_}

		case ${c} in
		wl-*|xwayland)
			if ! use wayland ; then
				myconf+=( --disable-${c} )
				continue
			fi

		;;
		esac

		myconf+=( $(use_enable ${u} ${c}) )

	done

	econf "${myconf[@]}"
}

src_install() {
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf

	if use doc ; then
		local HTML_DOCS=( doc/. )
	fi

	einstalldocs
	V=1 emake install DESTDIR="${D}" || die

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
