# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )
inherit gnome2-utils python-any-r1 toolchain-funcs

DESCRIPTION="A terminal emulator designed to integrate with the ROX environment"
HOMEPAGE="http://roxterm.sourceforge.net/"
SRC_URI="mirror://sourceforge/roxterm/${P}.tar.xz"

LICENSE="GPL-2 LGPL-3"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/dbus-glib-0.100
		dev-libs/glib:2
		x11-libs/gtk+:3
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/vte:2.91"
DEPEND="${RDEPEND}
		${PYTHON_DEPS}
		dev-libs/libxslt
		dev-python/lockfile
		virtual/pkgconfig
		|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
		nls? ( app-text/po4a sys-devel/gettext )"

src_configure() {
	local myconf=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		--prefix=/usr
		--docdir="/usr/share/doc/${PF}"
		--destdir="${D}"
	)

	use nls || myconf+=( --disable-gettext --disable-po4a --disable-translations )
	./mscript.py configure "${myconf[@]}"
}

src_compile() {
	./mscript.py build
}

src_install() {
	./mscript.py install
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
