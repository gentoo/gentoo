# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic gnome2 python-r1 virtualx

DESCRIPTION="GTK+2 bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc examples test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.8:2
	>=x11-libs/pango-1.16
	>=dev-libs/atk-1.12
	>=x11-libs/gtk+-2.24:2
	>=dev-python/pycairo-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/pygobject-2.26.8-r53:2[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=gnome-base/libglade-2.5:2.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		dev-libs/libxslt
		>=app-text/docbook-xsl-stylesheets-1.70.1 )
"

src_prepare() {
	# Fix declaration of codegen in .pc
	epatch "${FILESDIR}/${PN}-2.13.0-fix-codegen-location.patch"
	epatch "${FILESDIR}/${PN}-2.14.1-libdir-pc.patch"

	# Fix leaks of Pango objects
	epatch "${FILESDIR}/${PN}-2.24.0-fix-leaks.patch"

	# Fail when tests are failing, bug #391307
	epatch "${FILESDIR}/${PN}-2.24.0-test-fail.patch"

	# Fix broken tests, https://bugzilla.gnome.org/show_bug.cgi?id=709304
	epatch "${FILESDIR}/${P}-test_dialog.patch"

	# Fix build on Darwin
	epatch "${FILESDIR}/${PN}-2.24.0-quartz-objc.patch"

	# Examples is handled "manually"
	sed -e 's/\(SUBDIRS = .* \)examples/\1/' \
		-i Makefile.am Makefile.in || die

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #466968

	AT_M4DIR="m4" eautoreconf

	prepare_pygtk() {
		mkdir -p "${BUILD_DIR}" || die
	}
	python_foreach_impl prepare_pygtk
}

src_configure() {
	use hppa && append-flags -ffunction-sections
	configure_pygtk() {
		ECONF_SOURCE="${S}" gnome2_src_configure \
			$(use_enable doc docs) \
			--with-glade \
			--enable-thread
	}
	python_foreach_impl run_in_build_dir configure_pygtk
}

src_compile() {
	python_foreach_impl run_in_build_dir gnome2_src_compile
}

src_test() {
	# Let tests pass without permissions problems, bug #245103
	gnome2_environment_reset
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		cd tests
		Xemake check-local
	}
	python_foreach_impl run_in_build_dir testing
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL MAPPING NEWS README THREADS TODO

	if use examples; then
		rm examples/Makefile*
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	python_foreach_impl run_in_build_dir gnome2_src_install
	prune_libtool_files --modules
}
