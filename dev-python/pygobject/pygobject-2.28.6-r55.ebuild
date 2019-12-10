# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-r1 virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="examples libffi test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	dev-lang/python-exec:2
	libffi? ( virtual/libffi:= )
	${PYTHON_DEPS}
"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc )
"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.23"

src_prepare() {
	# Fix FHS compliance, see upstream bug #535524
	epatch "${FILESDIR}/${PN}-2.28.3-fix-codegen-location.patch"

	# Do not build tests if unneeded, bug #226345
	epatch "${FILESDIR}/${PN}-2.28.3-make_check.patch"

	# Support installation for multiple Python versions, upstream bug #648292
	epatch "${FILESDIR}/${PN}-2.28.3-support_multiple_python_versions.patch"

	# Disable tests that fail
	epatch "${FILESDIR}/${P}-disable-failing-tests.patch"

	# Disable introspection tests when we build with --disable-introspection
	epatch "${FILESDIR}/${P}-tests-no-introspection.patch"

	# Fix warning spam
	epatch "${FILESDIR}/${P}-set_qdata.patch"
	epatch "${FILESDIR}/${P}-gio-types-2.32.patch"

	# Fix glib-2.36 compatibility, bug #486602
	epatch "${FILESDIR}/${P}-glib-2.36-class_init.patch"

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.ac || die

	eautoreconf
	gnome2_src_prepare

	python_copy_sources

	prepare_shebangs() {
		# Make a backup with unconverted shebangs to keep python_doscript happy
		cp codegen/codegen.py pygobject-codegen-2.0
		sed -e "s%#! \?/usr/bin/env python%#!${PYTHON}%" \
			-i codegen/*.py || die "shebang convertion failed"
	}
	python_foreach_impl run_in_build_dir prepare_shebangs
}

src_configure() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	# --disable-introspection and --disable-cairo because we use pygobject:3
	# for introspection support
	G2CONF="${G2CONF}
		--disable-introspection
		--disable-cairo
		$(use_with libffi ffi)"

	python_foreach_impl run_in_build_dir gnome2_src_configure
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

# FIXME: With python multiple ABI support, tests return 1 even when they pass
src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	export GIO_USE_VFS="local" # prevents odd issues with deleting ${T}/.gvfs

	testing() {
		export XDG_CACHE_HOME="${T}/${EPYTHON}"
		run_in_build_dir Xemake -j1 check
		unset XDG_CACHE_HOME
	}
	python_foreach_impl testing
	unset GIO_USE_VFS
}

src_install() {
	installing() {
		local f prefixed_sitedir

		gnome2_src_install

		python_doscript pygobject-codegen-2.0

		# Don't keep multiple copies of pygobject-codegen-2.0 script
		prefixed_sitedir=$(python_get_sitedir)
		dosym "${prefixed_sitedir#${EPREFIX}}/gtk-2.0/codegen/codegen.py" "/usr/lib/python-exec/${EPYTHON}/pygobject-codegen-2.0"
	}
	python_foreach_impl run_in_build_dir installing

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

run_in_build_dir() {
	pushd "${BUILD_DIR}" > /dev/null || die
	"$@"
	popd > /dev/null
}
