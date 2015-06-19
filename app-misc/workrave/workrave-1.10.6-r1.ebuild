# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/workrave/workrave-1.10.6-r1.ebuild,v 1.2 2015/04/08 07:30:37 mgorny Exp $

EAPI=5
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1 versionator

DESCRIPTION="Helpful utility to attack Repetitive Strain Injury (RSI)"
HOMEPAGE="http://www.workrave.org/"
# SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
MY_PV=$(replace_all_version_separators '_')
SRC_URI="https://github.com/rcaelers/${PN}/archive/v${MY_PV}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

# dbus support looks to be used only for trying to use panel applets on gnome3!
IUSE="ayatana doc distribution gnome gstreamer mate nls pulseaudio test xfce"

RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0:3
	>=dev-cpp/gtkmm-3.0.0:3.0
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/libsigc++-2.2.4.2:2
	ayatana? (
		>=dev-libs/libdbusmenu-0.4[gtk3]
		>=dev-libs/libindicator-0.4:3 )
	distribution? ( >=net-libs/gnet-2 )
	gnome? ( >=gnome-base/gnome-shell-3.6.2 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	mate? ( mate-base/mate-applets )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	xfce? (
		>=x11-libs/gtk+-2.6.0:2
		>=xfce-base/xfce4-panel-4.4 )
	x11-libs/libXScrnSaver
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXt
	x11-libs/libXmu
"
#        dbus? (
#                >=sys-apps/dbus-1.2
#                dev-libs/dbus-glib )

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/recordproto
	dev-python/cheetah
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-utils
		app-text/xmlto )
	nls? ( >=sys-devel/gettext-0.17 )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-dbus \
		--enable-exercises \
		--disable-experimental \
		--disable-gnome2 \
		--disable-static \
		--disable-xml \
		$(use_enable ayatana indicator) \
		$(use_enable doc manual) \
		$(use_enable distribution) \
		$(use_enable gnome gnome3) \
		$(use_enable gstreamer) \
		$(use_enable mate) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable test tests) \
		$(use_enable xfce)
}
