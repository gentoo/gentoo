# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 pax-utils python-r1

MY_P=${P/_/-}

S=${WORKDIR}/${MY_P}

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo feeds"
HOMEPAGE="http://liferea.sourceforge.net/"
SRC_URI="https://github.com/lwindolf/${PN}/releases/download/v${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="ayatana libnotify"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-db/sqlite-3.7.0:3
	>=dev-libs/glib-2.28.0:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	>=dev-libs/libpeas-1.0.0[gtk,python,${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.19
	gnome-base/gsettings-desktop-schemas
	>=net-libs/libsoup-2.28.2:2.4
	>=net-libs/webkit-gtk-1.6.1:3
	x11-libs/gtk+:3
	>=x11-libs/pango-1.4.0
	ayatana? ( dev-libs/libindicate )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	gnome2_src_prepare
	eautoreconf
}

src_configure() {
	gnome2_src_configure \
		--disable-schemas-compile \
		$(use_enable ayatana libindicate) \
		$(use_enable libnotify)
}

src_install() {
	gnome2_src_install

	# bug #338213
	# Uses webkit's JIT. Needs mmap('rwx') to generate code in runtime.
	# MPROTECT policy violation. Will sit here until webkit will
	# get optional JIT.
	pax-mark m "${D%/}"/usr/bin/liferea

	einfo "If you want to enhance the functionality of this package,"
	einfo "you should consider installing:"
	einfo "    dev-libs/dbus-glib"
	einfo "    net-misc/networkmanager"
}
