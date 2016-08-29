# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit flag-o-matic gnome2-utils python-single-r1 toolchain-funcs

MY_PV="${PV}-20150830"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A bible study frontend for Sword (formerly known as GnomeSword)"
HOMEPAGE="http://xiphos.org/"
SRC_URI="mirror://sourceforge/gnomesword/${MY_P}.tar.gz"

LICENSE="GPL-2 FDL-1.1 LGPL-2 MIT MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=app-text/sword-1.7.4
	>=dev-libs/glib-2[${PYTHON_USEDEP}]
	dev-libs/libxml2[${PYTHON_USEDEP}]
	gnome-base/gconf[${PYTHON_USEDEP}]
	gnome-extra/gtkhtml:4.0
	>=gnome-extra/libgsf-1.14
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	dbus? ( dev-libs/dbus-glib )
"
DEPEND="${RDEPEND}
	app-text/docbook2X
	app-text/gnome-doc-utils[${PYTHON_USEDEP}]
	app-text/rarian
	dev-libs/libxslt[${PYTHON_USEDEP}]
	dev-util/intltool
	net-libs/biblesync
	virtual/pkgconfig
	sys-devel/gettext
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e '/FLAGS_DEBUG/s:-g:-Wall:' \
		-e '/FLAGS_RELEASE/s:-O2:-Wall:' \
		wscript || die
}

src_configure() {
	append-cppflags -DNO_SWORD_SET_RENDER_NOTE_NUMBERS=1

	tc-export AR CC CPP CXX RANLIB

	CCFLAGS="${CFLAGS}" \
	LINKFLAGS="${LDFLAGS}" \
	SGML2MAN="$(type -P docbook2man.pl)" \
		./waf -v \
			--prefix=/usr \
			--gtk=3 \
			--enable-webkit2 \
			--debug-level=$(use debug && echo debug || echo release) \
			$(use dbus || echo --disable-dbus) \
			configure || die
}

src_compile() {
	./waf -v build || die
}

src_install() {
	./waf -v --destdir="${D}" install || die

	doman ${PN}.1
	dodoc AUTHORS ChangeLog README RELEASE-NOTES TODO

	dodoc Xiphos.ogg
	docompress -x /usr/share/doc/${PF}/Xiphos.ogg

	rm -rf "${ED}"/usr/share/doc/${PN}
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
