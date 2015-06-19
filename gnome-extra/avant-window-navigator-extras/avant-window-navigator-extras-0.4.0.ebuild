# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/avant-window-navigator-extras/avant-window-navigator-extras-0.4.0.ebuild,v 1.8 2013/02/07 22:21:06 ulm Exp $

EAPI=4

GCONF_DEBUG=no
GNOME2_LA_PUNT=yes

PYTHON_DEPEND="2:2.6"

inherit eutils gnome2 python

DESCRIPTION="Applets for the Avant Window Navigator"
HOMEPAGE="http://launchpad.net/awn-extras"
SRC_URI="http://launchpad.net/awn-extras/0.4/${PV}/+download/awn-extras-${PV}.tar.gz"

LICENSE="BSD CC-BY-SA-3.0 GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gconf gstreamer webkit"

RDEPEND="dev-python/dbus-python
	dev-python/feedparser
	dev-python/gdata
	dev-python/librsvg-python
	dev-python/notify-python
	dev-python/pycairo
	dev-python/pygobject:2
	dev-python/pygtk:2
	dev-python/python-dateutil
	dev-python/vobject
	>=gnome-base/libgtop-2
	>=gnome-extra/avant-window-navigator-${PV}[gconf?]
	sys-apps/dbus
	>=x11-libs/gtk+-2.18:2
	x11-libs/libdesktop-agnostic
	>=x11-libs/libnotify-0.7
	>=x11-libs/libwnck-2.22:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXrender
	x11-libs/vte:0
	gconf? (
		>=gnome-base/gconf-2
		dev-python/gconf-python
		)
	gstreamer? (
		media-libs/gstreamer:0.10
		dev-python/gst-python:0.10
		)
	webkit? ( net-libs/webkit-gtk:2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

S=${WORKDIR}/awn-extras-${PV}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	if has_version gnome-extra/avant-window-navigator[vala]; then
		export VALAC="$(type -P valac-0.10)"
		export VALA_GEN_INTROSPECT="$(type -P vapigen-0.10)"
	else
		export VALAC=dIsAbLeVaLa
		export VALA_GEN_INTROSPECT=dIsAbLeVaLa
	fi

	local sound=no
	use gstreamer && sound=gstreamer

	G2CONF="--disable-static
		--enable-sound=${sound}
		--disable-pymod-checks
		$(use_enable gconf schemas-install)
		$(use_with gconf)
		--without-gnome
		--without-mozilla
		$(use_with webkit)"

	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-libnotify-0.7.patch \
		"${FILESDIR}"/${P}-glib-2.31.patch \
		"${FILESDIR}"/${P}-to-do.py.patch

	>py-compile

	gnome2_src_prepare
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize awn
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup awn
}
