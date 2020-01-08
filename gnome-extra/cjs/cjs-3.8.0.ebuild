# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2 pax-utils virtualx

DESCRIPTION="Linux Mint's fork of gjs for Cinnamon"
HOMEPAGE="http://developer.linuxmint.com/projects/cinnamon-projects.html"
SRC_URI="https://github.com/linuxmint/cjs/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo examples gtk test"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-lang/spidermonkey:52
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
	sys-devel/autoconf-archive
"
# Cinnamon 2.2 does not work with this release.
RDEPEND="${RDEPEND}
	!<gnome-extra/cinnamon-2.4
"

RESTRICT="test"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
	sed -ie "s/gjs-console/cjs-console/g" \
		"${S}"/installed-tests/scripts/testCommandLine.sh \
		"${S}"/installed-tests/scripts/testWarnings.sh || die

	sed -ie "s/Gjs-WARNING/Cjs-WARNING/g" \
		"${S}"/installed-tests/scripts/testCommandLine.sh || die

	sed -ie "s/'Gjs'/'Cjs'/g" \
		"${S}"/installed-tests/js/testExceptions.js \
		"${S}"/installed-tests/js/testSignals.js \
		"${S}"/installed-tests/js/testGDBus.js \
		"${S}"/installed-tests/js/testEverythingBasic.js || die
}

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
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
