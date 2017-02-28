# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2 pax-utils virtualx

DESCRIPTION="Linux Mint's fork of gjs for Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cjs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk test"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-lang/spidermonkey:24
	>=dev-libs/glib-2.37.3:2
	>=dev-libs/gobject-introspection-1.38:=
	sys-libs/readline:0
	virtual/libffi
	cairo? ( x11-libs/cairo[X,glib] )
	gtk? ( x11-libs/gtk+:3 )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"
# Cinnamon 2.2 does not work with this release.
RDEPEND="${RDEPEND}
	!<gnome-extra/cinnamon-2.4
"

src_prepare() {
	# Disable broken unittests
	eapply "${FILESDIR}"/${PN}-2.4.0-disable-unittest-*.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-coverage \
		$(use_with cairo) \
		$(use_with gtk)
}

src_test() {
	virtx emake check
}

src_install() {
	# installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for cjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/cjs-console"
}
