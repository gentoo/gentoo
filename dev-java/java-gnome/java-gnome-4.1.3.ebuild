# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"
PYTHON_COMPAT=( python2_7 )

inherit eutils versionator java-pkg-2 multilib python-r1 virtualx

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Java bindings for GTK and GNOME"
HOMEPAGE="http://java-gnome.sourceforge.net/"
SRC_URI="mirror://gnome/sources/${PN}/$(get_version_component_range 1-2)/${MY_P}.tar.xz"

LICENSE="GPL-2-with-linking-exception"
SLOT="4.1"
KEYWORDS="amd64 ~ppc x86"

COMMON_DEP="
	app-text/enchant:0
	dev-libs/atk:0
	>=dev-libs/glib-2.28:2
	dev-libs/libunique:3
	gnome-base/librsvg:2
	>=x11-libs/cairo-1.10.0[svg]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0
	>=x11-libs/libnotify-0.7.0
	x11-libs/pango:0
	${PYTHON_DEPS}"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.6"

DEPEND="${COMMON_DEP}
	dev-java/junit:0
	dev-lang/perl
	>=virtual/jdk-1.6
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	java-pkg-2_pkg_setup
}

src_configure() {
	# Handwritten in perl so not using econf
	./configure prefix=/usr libdir=/usr/$(get_libdir)/${PN}-${SLOT} jardir=/usr/share/${PN}-${SLOT}/lib || die
}

src_compile() {
	emake
	use doc && DISPLAY= emake doc
}

# Needs X11, fails even then
RESTRICT="test"
src_test() {
	Xemake test
}

src_install(){
	emake -j1 DESTDIR="${D}" install
	java-pkg_regjar /usr/share/${PN}-${SLOT}/lib/gtk-${SLOT}.jar
	java-pkg_regjar /usr/share/${PN}-${SLOT}/lib/gtk.jar

	use doc && java-pkg_dojavadoc doc/api
	use examples && java-pkg_doexamples doc/examples
	use source && java-pkg_dosrc src/bindings/org
}
