# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )
inherit autotools gnome2-utils linux-info python-single-r1 systemd xdg-utils

DESCRIPTION="Simple and intuitive GTK+ Bluetooth Manager"
HOMEPAGE="https://github.com/blueman-project/blueman"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/blueman-project/blueman.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/blueman-project/${PN}/releases/download/${PV/_/.}/${P/_/.}.tar.xz"
	S=${WORKDIR}/${P/_/.}
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

# icons are GPL-2
# source files are mixed GPL-3+ and GPL-2+
LICENSE="GPL-3+ GPL-2"
SLOT="0"
IUSE="appindicator network nls policykit pulseaudio"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')
	>=net-wireless/bluez-5:=
	${PYTHON_DEPS}"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_MULTI_USEDEP}]
	')
	virtual/pkgconfig
	nls? ( dev-util/intltool sys-devel/gettext )"
RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
	')
	sys-apps/dbus
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	|| (
		x11-themes/adwaita-icon-theme
		x11-themes/faenza-icon-theme
		x11-themes/mate-icon-theme
	)
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	network? (
		net-firewall/iptables
		|| (
			sys-apps/net-tools
			sys-apps/iproute2
		)
		|| (
			net-dns/dnsmasq
			net-misc/dhcp
			>=net-misc/networkmanager-0.8
		)
	)
	policykit? ( sys-auth/polkit )
	pulseaudio? (
		|| (
			media-sound/pulseaudio[bluetooth]
			media-sound/pulseaudio-modules-bt
		)
	)
	!net-wireless/gnome-bluetooth
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_pretend() {
	if use network; then
		local CONFIG_CHECK="~BRIDGE ~IP_NF_IPTABLES
			~IP_NF_NAT ~IP_NF_TARGET_MASQUERADE"
		check_extra_config
	fi
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	# replace py-compile to fix py3
	[[ ${PV} == 9999 ]] && eautoreconf || eautomake
}

src_configure() {
	local myconf=(
		--docdir=/usr/share/doc/${PF}
		--disable-runtime-deps-check
		--disable-static
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		--with-dhcp-config="/etc/dhcp/dhcpd.conf"
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

	rm "${D}"/$(python_get_sitedir)/*.la || die
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
