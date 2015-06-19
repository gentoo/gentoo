# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/enlightenment/enlightenment-0.17.6.ebuild,v 1.4 2014/12/27 17:03:42 tommy Exp $

EAPI=5

inherit autotools enlightenment

DESCRIPTION="Enlightenment DR17 window manager"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="amd64 x86"
SLOT="0.17/${PV%%_*}"

# The @ is just an anchor to expand from
__EVRY_MODS=""
__CONF_MODS="
	+@applications +@dialogs +@display +@edgebindings
	+@interaction +@intl +@keybindings +@menus
	+@paths +@performance +@randr +@shelves +@theme
	+@window-manipulation +@window-remembers"
__NORM_MODS="
	@access +@backlight +@battery +@clock +@comp +@connman +@cpufreq +@dropshadow
	+@everything +@fileman +@fileman-opinfo +@gadman +@ibar +@ibox +@illume2
	+@mixer	+@msgbus +@notification +@pager +@quickaccess +@shot +@start
	+@syscon +@systray +@tasks +@temperature +@tiling +@winlist +@wizard +@xkbswitch"
IUSE_E_MODULES="
	${__CONF_MODS//@/enlightenment_modules_conf-}
	${__NORM_MODS//@/enlightenment_modules_}"

IUSE="pam spell static-libs +udev ukit ${IUSE_E_MODULES}"

RDEPEND="
	pam? ( sys-libs/pam )
	|| ( >=dev-libs/efl-1.8.4[X,eet,jpeg(+),png] >=dev-libs/efl-1.8.4[xcb,eet,jpeg(+),png] )
	>=dev-libs/e_dbus-1.7.10
	ukit? ( >=dev-libs/e_dbus-1.7.10[udev] )
	x11-libs/xcb-util-keysyms"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P%%_*}

src_prepare() {
	sed -i "s:1.7.10:1.7.9:g" configure.ac
	eautoreconf
	epatch "${FILESDIR}"/quickstart.diff
	enlightenment_src_prepare
}

src_configure() {
	E_ECONF+=(
		--disable-install-sysactions
		--disable-elementary
		$(use_enable doc)
		--disable-device-hal
		--enable-emotion
		--disable-mount-hal
		$(use_enable nls)
		$(use_enable pam)
		--enable-device-udev
		$(use_enable udev mount-eeze)
		$(use_enable ukit mount-udisks)
		--disable-physics
	)
	local u c
	for u in ${IUSE_E_MODULES} ; do
		u=${u#+}
		c=${u#enlightenment_modules_}
		E_ECONF+=( $(use_enable ${u} ${c}) )
	done
	enlightenment_src_configure
}

src_install() {
	enlightenment_src_install
	insinto /etc/enlightenment
	newins "${FILESDIR}"/gentoo-sysactions.conf sysactions.conf
}
