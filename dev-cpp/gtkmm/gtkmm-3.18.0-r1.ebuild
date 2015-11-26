# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="3.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="aqua doc examples test wayland X"
REQUIRED_USE="|| ( aqua wayland X )"

RDEPEND="
	>=dev-cpp/glibmm-2.46.1:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.18.0:3[aqua?,wayland?,X?,${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.28:2[${MULTILIB_USEDEP}]
	>=dev-cpp/atkmm-2.24.1[${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.12.0[${MULTILIB_USEDEP}]
	>=dev-cpp/pangomm-2.38.1:1.4[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	examples? ( >=media-libs/libepoxy-1.2[${MULTILIB_USEDEP}] )
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen )
"
#	dev-cpp/mm-common"
# eautoreconf needs mm-common

src_prepare() {
	if ! use test; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed 1 failed"
	fi

	if ! use examples; then
		# don't waste time building tests
		sed 's/^\(SUBDIRS =.*\)demos\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed 2 failed"
	fi

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		--enable-api-atkmm \
		$(multilib_native_use_enable doc documentation) \
		$(use_enable aqua quartz-backend) \
		$(use_enable wayland wayland-backend) \
		$(use_enable X x11-backend)
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog PORTING NEWS README"
	einstalldocs
}
