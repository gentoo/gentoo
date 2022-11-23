# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{8..11} )

inherit autotools distutils-r1 gnome2-utils linux-info systemd xdg-utils

DESCRIPTION="Simple and intuitive GTK+ Bluetooth Manager"
HOMEPAGE="https://github.com/blueman-project/blueman/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/blueman-project/blueman.git"
else
	SRC_URI="
		https://github.com/blueman-project/blueman/releases/download/${PV/_/.}/${P/_/.}.tar.xz
	"
	S=${WORKDIR}/${P/_/.}
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

# icons are GPL-2
# source files are mixed GPL-3+ and GPL-2+
LICENSE="GPL-3+ GPL-2"
SLOT="0"
IUSE="network nls policykit pulseaudio"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	>=net-wireless/bluez-5:=
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${DEPEND}
	$(python_gen_cond_dep '
		dev-python/pycairo[${PYTHON_USEDEP}]
	')
	sys-apps/dbus
	x11-libs/gtk+:3[introspection,X]
	x11-libs/libnotify[introspection]
	|| (
		x11-themes/adwaita-icon-theme
		x11-themes/faenza-icon-theme
		x11-themes/mate-icon-theme
	)
	network? (
		net-firewall/iptables
		|| (
			sys-apps/net-tools
			sys-apps/iproute2
		)
		|| (
			net-dns/dnsmasq
			net-misc/dhcp
			>=net-misc/networkmanager-0.8[introspection]
		)
	)
	policykit? (
		sys-auth/polkit
	)
	pulseaudio? (
		|| (
			media-sound/pulseaudio-daemon[bluetooth]
			media-video/pipewire[bluetooth]
			<media-sound/pulseaudio-15.99.1[bluetooth]
		)
	)
"

pkg_pretend() {
	if use network; then
		local CONFIG_CHECK="
			~BRIDGE
			~IP_NF_IPTABLES
			~IP_NF_NAT
			~IP_NF_TARGET_MASQUERADE
		"
		check_extra_config
	fi
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	else
		# remove this when upstream switches to automake with .pyc fix
		eautomake
	fi
	distutils-r1_src_prepare
}

python_configure() {
	local myconf=(
		--disable-runtime-deps-check
		--disable-static
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-systemduserunitdir="$(systemd_get_userunitdir)"
		--with-dhcp-config="/etc/dhcp/dhcpd.conf"
		$(use_enable policykit polkit)
		$(use_enable nls)
		$(use_enable pulseaudio)
		# thunar integration is a single data file with no extra deps
		# so install it unconditionally
		--enable-thunar-sendto
	)
	econf "${myconf[@]}"
}

python_compile() {
	default
}

python_test() {
	# import tests are not very valuable and fail if /dev/rfkill
	# does not exist
	"${EPYTHON}" -m unittest -v test/test_gobject.py || die
}

python_install() {
	default

	if use policykit; then
		# Allow users in plugdev group to modify connections
		insinto /usr/share/polkit-1/rules.d
		doins "${FILESDIR}/01-org.blueman.rules"
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
