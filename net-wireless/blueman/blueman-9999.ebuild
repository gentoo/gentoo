# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/blueman/blueman-9999.ebuild,v 1.10 2015/08/08 15:11:45 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )
inherit eutils python-single-r1 gnome2-utils autotools

DESCRIPTION="GTK+ Bluetooth Manager, designed to be simple and intuitive for everyday bluetooth tasks"
HOMEPAGE="https://github.com/blueman-project/blueman"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/blueman-project/blueman.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/blueman-project/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="appindicator network nls policykit pulseaudio thunar"

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
		x11-themes/faenza-icon-theme
		x11-themes/gnome-icon-theme
		x11-themes/mate-icon-theme
	)
	appindicator? ( dev-libs/libappindicator:3[introspection] )
	network? ( || ( net-dns/dnsmasq
		net-misc/dhcp
		>=net-misc/networkmanager-0.8 ) )
	policykit? ( sys-auth/polkit )
	pulseaudio? ( media-sound/pulseaudio[bluetooth] )
	thunar? ( xfce-base/thunar )
	!net-wireless/gnome-bluetooth
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-9999-set-codeset-for-gettext-to-UTF-8-always.patch"
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--disable-runtime-deps-check \
		--disable-static \
		$(use_enable appindicator) \
		$(use_enable policykit polkit) \
		$(use_enable nls) \
		$(use_enable pulseaudio) \
		$(use_enable thunar thunar-sendto)
}

src_install() {
	default

	python_fix_shebang "${D}"
	rm "${D}"/$(python_get_sitedir)/*.la || die
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
