# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libpeas/libpeas-1.12.1-r1.ebuild,v 1.3 2015/03/15 13:18:30 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit gnome2 multilib python-r1 virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="http://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="+gtk glade +python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} ?? ( $(python_gen_useflags 'python3*') ) )"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.39
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0.0:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.11
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"

src_configure() {
	# --disable-seed because it's dead, bug #541890
	local myconf=(
		$(use_enable glade glade-catalog)
		$(use_enable gtk)
		--disable-deprecation
		--disable-seed
		--disable-static

		# possibly overriden below
		--disable-python{2,3}
	)
	# Wtf, --disable-gcov, --enable-gcov=no, --enable-gcov, all enable gcov
	# What do we do about gdb, valgrind, gcov, etc?

	python_configure() {
		local v
		python_is_python3 && v=3 || v=2
		myconf+=(
			"--enable-python${v}"
			# it is just 'PYTHON' for py3 in the build system
			"PYTHON${v#3}=${PYTHON}"
			"PYTHON${v}_CONFIG=${PYTHON}-config"
		)
	}
	use python && python_foreach_impl python_configure

	gnome2_src_configure "${myconf[@]}"
}

src_test() {
	# FIXME: Tests fail because of some bug involving Xvfb and Gtk.IconTheme
	# DO NOT REPORT UPSTREAM, this is not a libpeas bug.
	# To reproduce:
	# >>> from gi.repository import Gtk
	# >>> Gtk.IconTheme.get_default().has_icon("gtk-about")
	# This should return True, it returns False for Xvfb
	Xemake check
}
