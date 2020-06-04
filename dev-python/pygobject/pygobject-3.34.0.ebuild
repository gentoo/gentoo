# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit gnome.org meson python-r1 virtualx xdg

DESCRIPTION="Python bindings for GObject Introspection"
HOMEPAGE="https://pygobject.readthedocs.io/"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cairo examples test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.48:2
	>=dev-libs/gobject-introspection-1.54:=
	virtual/libffi:=
	cairo? (
		>=dev-python/pycairo-1.11.1[${PYTHON_USEDEP}]
		x11-libs/cairo[glib] )
"
DEPEND="${RDEPEND}
	test? (
		dev-libs/atk[introspection]
		dev-python/pytest[${PYTHON_USEDEP}]
		x11-libs/gdk-pixbuf:2[introspection,jpeg]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection] )
"
BDEPEND="
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

src_configure() {
	configuring() {
		meson_src_configure \
			$(meson_use cairo pycairo) \
			$(meson_use test tests) \
			-Dpython="${EPYTHON}"
	}

	python_foreach_impl configuring
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	local -x GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs
	local -x GIO_USE_VOLUME_MONITOR="unix" # prevent udisks-related failures in chroots, bug #449484

	testing() {
		local -x XDG_CACHE_HOME="${T}/${EPYTHON}"
		meson_src_test || die "test failed for ${EPYTHON}"
	}
	virtx python_foreach_impl testing
}

src_install() {
	installing() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl installing
	use examples && dodoc -r examples
}
