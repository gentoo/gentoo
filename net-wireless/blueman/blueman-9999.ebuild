# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python{3_4,3_5,3_6} )
inherit gnome2-utils linux-info python-single-r1 systemd

DESCRIPTION="Simple and intuitive GTK+ Bluetooth Manager"
HOMEPAGE="https://github.com/blueman-project/blueman"

if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/blueman-project/blueman.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/blueman-project/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="appindicator network nls policykit pulseaudio"

COMMON_DEPEND="
	dev-python/pygobject:3
	>=net-wireless/bluez-5:=
	${PYTHON_DEPS}"
DEPEND="${COMMON_DEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	virtual/pkgconfig
	nls? ( dev-util/intltool sys-devel/gettext )"
RDEPEND="${COMMON_DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	sys-apps/dbus
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	|| (
		x11-themes/adwaita-icon-theme
		x11-themes/faenza-icon-theme
		x11-themes/gnome-icon-theme
		x11-themes/mate-icon-theme
	)
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	network? (
		net-firewall/iptables
		sys-apps/net-tools
		|| (
			net-dns/dnsmasq
			net-misc/dhcp
			>=net-misc/networkmanager-0.8
		)
	)
	policykit? ( sys-auth/polkit )
	pulseaudio? ( media-sound/pulseaudio[bluetooth] )
	!net-wireless/gnome-bluetooth
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_pretend() {
	if use network; then
		local CONFIG_CHECK="~BRIDGE ~IP_NF_IPTABLES
			~IP_NF_NAT ~IP_NF_TARGET_MASQUERADE"
		linux-info_pkg_setup
	fi
}

pkg_setup() {
	pkg_pretend
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	local myconf=(
		--docdir=/usr/share/doc/${PF}
		--disable-runtime-deps-check
		--disable-static
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		$(use_enable appindicator)
		$(use_enable policykit polkit)
		$(use_enable nls)
		$(use_enable pulseaudio)
		# thunar integration is a single data file with no extra deps
		# so install it unconditionally
		--enable-thunar-sendto
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	if use policykit; then
		# Allow users in plugdev group to modify connections
		insinto /usr/share/polkit-1/rules.d
		doins "${FILESDIR}/01-org.blueman.rules"
	fi

	python_fix_shebang "${D}"
	rm "${D}"/$(python_get_sitedir)/*.la || die
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
