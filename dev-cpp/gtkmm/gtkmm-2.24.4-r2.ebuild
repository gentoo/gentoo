# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2 multilib-minimal

DESCRIPTION="C++ interface for GTK+"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="2.4"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc examples test"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.34.1:2[${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-2.24.15:2[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.28:2[${MULTILIB_USEDEP}]
	>=dev-cpp/atkmm-2.22.7[${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.10.0-r1[${MULTILIB_USEDEP}]
	>=dev-cpp/pangomm-2.34.0:1.4[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtkmmlibs-20140508
		!app-emulation/emul-linux-x86-gtkmmlibs[-abi_x86_32(-)] )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen )
"

src_prepare() {
	# Apply fixes from 2.24 branch
	epatch "${FILESDIR}"/${P}-papersize.patch
	epatch "${FILESDIR}"/${P}-missing-includes.patch
	epatch "${FILESDIR}"/${P}-newer-glibmm.patch

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
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	DOCS="AUTHORS ChangeLog PORTING NEWS README"
	einstalldocs
}
