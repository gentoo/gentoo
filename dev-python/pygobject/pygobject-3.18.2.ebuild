# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit eutils gnome2 python-r1 virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cairo examples test +threads"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	test? ( cairo )
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.39:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.10.0[${PYTHON_USEDEP}]
		x11-libs/cairo )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	cairo? ( x11-libs/cairo[glib] )
	test? (
		dev-libs/atk[introspection]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
		x11-libs/cairo[glib]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]
		python_targets_python2_7? ( dev-python/pyflakes[$(python_gen_usedep python2_7)] ) )
"
# gnome-base/gnome-common required by eautoreconf

# We now disable introspection support in slot 2 per upstream recommendation
# (see https://bugzilla.gnome.org/show_bug.cgi?id=642048#c9); however,
# older versions of slot 2 installed their own site-packages/gi, and
# slot 3 will collide with them.
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"

src_prepare() {
	gnome2_src_prepare
	python_copy_sources
}

src_configure() {
	# Hard-enable libffi support since both gobject-introspection and
	# glib-2.29.x rdepend on it anyway
	# docs disabled by upstream default since they are very out of date
	configuring() {
		gnome2_src_configure \
			$(use_enable cairo) \
			$(use_enable threads thread)

		# Pyflakes tests work only in python2, bug #516744
		if use test && [[ ${EPYTHON} != python2.7 ]]; then
			sed -e 's/if type pyflakes/if false/' \
				-i Makefile || die "sed failed"
		fi
	}

	python_foreach_impl run_in_build_dir configuring
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs
	export GIO_USE_VOLUME_MONITOR="unix" # prevent udisks-related failures in chroots, bug #449484
	export SKIP_PEP8="yes"

	testing() {
		export XDG_CACHE_HOME="${T}/${EPYTHON}"
		run_in_build_dir Xemake check
		unset XDG_CACHE_HOME
	}
	python_foreach_impl testing
	unset GIO_USE_VFS
}

src_install() {
	DOCS="AUTHORS ChangeLog* NEWS README"

	python_foreach_impl run_in_build_dir gnome2_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
