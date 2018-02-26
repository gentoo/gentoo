# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_P=${P/_/-}

if [[ ${PV} == *9999 ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
fi

inherit enlightenment

DESCRIPTION="Enlightenment DR17 window manager"

LICENSE="BSD-2"
SLOT="0.17/${PV%%_*}"

__CONF_MODS=(
	applications bindings dialogs display
	interaction intl menus
	paths performance randr shelves theme
	window-manipulation window-remembers
)
__NORM_MODS=(
	appmenu backlight bluez4 battery
	clock conf connman cpufreq everything
	fileman fileman-opinfo gadman geolocation
	ibar ibox lokker
	mixer msgbus music-control notification
	pager packagekit pager-plain quickaccess
	shot start syscon systray tasks teamwork temperature tiling time
	winlist wireless wizard wl-desktop-shell wl-drm wl-text-input
	wl-weekeyboard wl-wl wl-x11 xkbswitch xwayland
)
IUSE_E_MODULES=(
	${__CONF_MODS[@]/#/enlightenment_modules_conf-}
	${__NORM_MODS[@]/#/enlightenment_modules_}
)

IUSE="pam spell static-libs systemd ukit wayland ${IUSE_E_MODULES[@]/#/+}"

RDEPEND="
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
	wayland? (
		dev-libs/efl[wayland]
		>=dev-libs/wayland-1.10.0
		>=x11-libs/pixman-0.31.1
		>=x11-libs/libxkbcommon-0.3.1
	)
	>=dev-libs/efl-1.18[X]
	x11-libs/xcb-util-keysyms"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/quickstart.diff
	enlightenment_src_prepare
}

# Sanity check to make sure module lists are kept up-to-date.
check_modules() {
	local detected=$(
		awk -F'[\\[\\](, ]' '$1 == "AC_E_OPTIONAL_MODULE" { print $3 }' \
		configure.ac | sed 's:_:-:g' | LC_COLLATE=C sort
	)
	local sorted=$(
		printf '%s\n' ${IUSE_E_MODULES[@]/#enlightenment_modules_} | \
		LC_COLLATE=C sort
	)
	if [[ ${detected} != "${sorted}" ]] ; then
		local out new old
		eerror "The ebuild needs to be kept in sync."
		echo "${sorted}" > ebuild-iuse
		echo "${detected}" > configure-detected
		out=$(diff -U 0 ebuild-iuse configure-detected | sed -e '1,2d' -e '/^@@/d')
		new=$(echo "${out}" | sed -n '/^+/{s:^+::;p}')
		old=$(echo "${out}" | sed -n '/^-/{s:^-::;p}')
		eerror "Add these modules: $(echo ${new})"
		eerror "Drop these modules: $(echo ${old})"
		die "please update the ebuild"
	fi
}

src_configure() {
	check_modules

	E_ECONF=(
		--disable-install-sysactions
		$(use_enable doc)
		$(use_enable nls)
		$(use_enable pam)
		$(use_enable systemd)
		--enable-device-udev
		$(use_enable ukit mount-udisks)
		$(use_enable wayland)
	)
	local u c
	for u in ${IUSE_E_MODULES[@]} ; do
		c=${u#enlightenment_modules_}
		# Disable modules by hand since we default to enabling them all.
		case ${c} in
		wl-*|xwayland)
			if ! use wayland ; then
				E_ECONF+=( --disable-${c} )
				continue
			fi
			;;
		esac
		E_ECONF+=( $(use_enable ${u} ${c}) )
	done
	enlightenment_src_configure
}

src_install() {
	enlightenment_src_install
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf
}
