# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit gnome2-utils python toolchain-funcs

DESCRIPTION="A terminal emulator designed to integrate with the ROX environment"
HOMEPAGE="http://roxterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/roxterm/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.16
	x11-libs/gtk+:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/vte:2.90"
DEPEND="${RDEPEND}
	dev-lang/python:2.7
	dev-libs/libxslt
	virtual/pkgconfig
	dev-python/lockfile
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	nls? ( app-text/po4a sys-devel/gettext )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	python_convert_shebangs 2 mscript.py

	# the "maitch" build system is complete junk. let's stab it...
	sed -i -e 's:TerminalEmulator:System;&:' roxterm.desktop || die
	sed -i -e '/ctx.install_doc/s:COPYING COPYING-LGPL ::' mscript.py || die
	sed -i -e "/CFLAGS/s:-O2 -g:${CFLAGS}:" {maitch,mscript}.py || die
	sed -i \
		-e 's:gcc:${CC}:' \
		-e "/LDFLAGS/s:'':'${LDFLAGS}':" \
		-e 's:--mode=link:--mode=link --tag=CC:' \
		maitch.py || die
}

src_configure() {
	local myconf=( GCC="$(tc-getCC)" --prefix=/usr --docdir=/usr/share/doc/${PF} --destdir="${D}" )
	use nls || myconf+=( --disable-gettext --disable-po4a --disable-translations )
	./mscript.py configure "${myconf[@]}"
}

src_compile() { ./mscript.py build; }
src_install() { ./mscript.py install; }
pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
