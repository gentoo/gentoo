# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.28"
VALA_USE_DEPEND="vapigen"

inherit gnome2 python-any-r1 vala

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.3/0" # subslot is libgrilo-0.3 soname suffix
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="gtk examples +introspection +network playlist test vala"
REQUIRED_USE="test? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.44:2
	dev-libs/libxml2:2
	net-libs/liboauth
	gtk? ( >=x11-libs/gtk+-3:3 )
	introspection? ( >=dev-libs/gobject-introspection-0.9:= )
	network? ( >=net-libs/libsoup-2.41.3:2.4 )
	playlist? ( >=dev-libs/totem-pl-parser-3.4.1 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	vala? ( $(vala_depend) )
	test? (
		$(python_gen_any_dep '
			dev-python/pygobject:2[${PYTHON_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]')
		media-plugins/grilo-plugins:0.2 )
"
# eautoreconf requires gnome-common

python_check_deps() {
	has_version "dev-python/pygobject:2[${PYTHON_USEDEP}]" && \
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	sed -e "s:GETTEXT_PACKAGE=grilo$:GETTEXT_PACKAGE=grilo-${SLOT}:" \
		-i configure.ac configure || die "sed configure.ac configure failed"

	# Don't build examples
	sed -e '/SUBDIRS/s/examples//' \
		-i Makefile.am -i Makefile.in || die

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	# --enable-debug only changes CFLAGS, useless for us
	gnome2_src_configure \
		--disable-static \
		--disable-debug \
		$(use_enable gtk test-ui) \
		$(use_enable introspection) \
		$(use_enable network grl-net) \
		$(use_enable playlist grl-pls) \
		$(use_enable test tests) \
		$(use_enable vala)
}

src_install() {
	gnome2_src_install
	# Upstream made this conditional on gtk-doc build...
	DOC_MODULE_VERSION=${SLOT%/*} \
	emake -C doc install DESTDIR="${ED}"

	if use examples; then
		# Install example code
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*.c
	fi
}
