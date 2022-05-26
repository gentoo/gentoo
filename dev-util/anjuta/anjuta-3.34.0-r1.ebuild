# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
# libanjuta-language-vala.so links to a specific slot of libvala; we want to
# avoid automagic behavior.
VALA_MIN_API_VERSION="0.56"
VALA_MAX_API_VERSION="${VALA_MIN_API_VERSION}"

GNOME2_EAUTORECONF="yes"
inherit gnome2 flag-o-matic readme.gentoo-r1 python-single-r1 vala

DESCRIPTION="A versatile IDE for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Anjuta https://gitlab.gnome.org/GNOME/anjuta/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE="debug devhelp glade +introspection subversion terminal test vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# FIXME: automagically uses gnome-extra/libgda:6 if available
# FIXME: make python dependency non-automagic
COMMON_DEPEND="
	>=dev-libs/glib-2.34:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.10:3
	>=dev-libs/libxml2-2.4.23
	>=dev-libs/gdl-3.5.5:3=
	>=x11-libs/gtksourceview-3:3.0

	sys-devel/autogen

	>=gnome-extra/libgda-5:5=
	dev-util/ctags

	x11-libs/libXext
	x11-libs/libXrender

	${PYTHON_DEPS}

	devhelp? ( >=dev-util/devhelp-3.7.4:= )
	glade? ( >=dev-util/glade-3.12:3.10= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	subversion? (
		>=dev-vcs/subversion-1.8:=
		>=net-libs/serf-1.2:1=
		>=dev-libs/apr-1:=
		>=dev-libs/apr-util-1:= )
	terminal? ( >=x11-libs/vte-0.27.6:2.91 )
	vala? ( $(vala_depend) )
"
# python plugins need pygobject and introspection; we have introspection optional, so while this is all a bit of a mess,
# restrict the pygobject dep to when python plugins can work in the build (the python loader explicitly imports gi.repository.Anjuta)
RDEPEND="${COMMON_DEPEND}
	introspection? (
		$(python_gen_cond_dep '
			>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}]
		')
	)
	gnome-base/gsettings-desktop-schemas
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.1
	sys-devel/bison
	sys-devel/flex
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	test? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.5 )
	app-text/yelp-tools
	dev-libs/gobject-introspection-common
	gnome-base/gnome-common
"
# yelp-tools, gi-common and gnome-common are required by eautoreconf

PATCHES=(
	"${FILESDIR}"/${PV}-Add-new-vala-support.patch
	"${FILESDIR}"/${PV}-autoconf-2.70.patch
	"${FILESDIR}"/${PV}-prefer-newer-vala.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	if use vala; then
		DISABLE_AUTOFORMATTING="yes"
		DOC_CONTENTS="To create a generic vala project you will need to specify
desired valac versioned binary to be used, to do that you
will need to:
1. Go to 'Build' -> 'Configure project'
2. Add 'VALAC=/usr/bin/valac-X.XX' (respecting quotes) to
'Configure options'."
	fi

	# COPYING is used in Anjuta's help/about entry
	DOCS="AUTHORS ChangeLog COPYING FUTURE MAINTAINERS NEWS README ROADMAP THANKS TODO"

	# Conflicts with -pg in a plugin, bug #266777
	filter-flags -fomit-frame-pointer

	# Do not build benchmarks, they are not installed and for dev purpose only
	sed -e '/SUBDIRS =/ s/benchmark//' \
		-i plugins/symbol-db/Makefile.{am,in} || die

	use vala && vala_setup
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-neon \
		--disable-static \
		$(use_enable debug) \
		$(use_enable devhelp plugin-devhelp) \
		$(use_enable glade plugin-glade) \
		$(use_enable glade glade-catalog) \
		$(use_enable introspection) \
		--disable-packagekit \
		$(use_enable subversion plugin-subversion) \
		$(use_enable subversion serf) \
		$(use_enable terminal plugin-terminal) \
		$(use_enable vala)
}

src_install() {
	# COPYING is used in Anjuta's help/about entry
	docompress -x "/usr/share/doc/${PF}/COPYING"

	# Anjuta uses a custom rule to install DOCS, get rid of it
	gnome2_src_install
	rm -rf "${ED}"/usr/share/doc/${PN} || die "rm failed"

	use vala && readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	use vala && readme.gentoo_print_elog
}
