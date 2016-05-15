# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )
VALA_MIN_API_VERSION="0.26"
VALA_MAX_API_VERSION="0.26" # configure explicitly checks for that version
VALA_USE_DEPEND="vapigen"

inherit autotools db-use eutils flag-o-matic gnome2 java-pkg-opt-2 python-single-r1 vala

DESCRIPTION="GNOME database access library"
HOMEPAGE="http://www.gnome-db.org/"
LICENSE="GPL-2+ LGPL-2+"

IUSE="berkdb canvas firebird gnome-keyring gtk graphviz http +introspection json ldap mdb mysql oci8 postgres reports sourceview ssl vala"
REQUIRED_USE="
	reports? ( ${PYTHON_REQUIRED_USE} )
	canvas? ( gtk )
	graphviz? ( gtk )
	sourceview? ( gtk )
	vala? ( introspection )
"
# firebird license is not GPL compatible

SLOT="5/4" # subslot = libgda-5.0 soname version
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.32:2
	>=dev-libs/libxml2-2
	dev-libs/libxslt
	sys-libs/readline:0=
	sys-libs/ncurses:0=
	berkdb? ( sys-libs/db:* )
	firebird? ( dev-db/firebird )
	gnome-keyring? ( app-crypt/libsecret )
	gtk? (
		>=x11-libs/gtk+-3.0.0:3
		canvas? ( x11-libs/goocanvas:2.0= )
		sourceview? ( x11-libs/gtksourceview:3.0 )
		graphviz? ( media-gfx/graphviz )
	)
	http? ( >=net-libs/libsoup-2.24:2.4 )
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	json? ( dev-libs/json-glib )
	ldap? ( net-nds/openldap:= )
	mdb? ( >app-office/mdbtools-0.5:= )
	mysql? ( virtual/mysql:= )
	postgres? ( dev-db/postgresql:= )
	reports? (
		${PYTHON_DEPS}
		dev-java/fop
		dev-python/reportlab )
	ssl? ( dev-libs/openssl:= )
	>=dev-db/sqlite-3.6.22:3=
	vala? ( dev-libs/libgee:0.8 )
"

# java dep shouldn't rely on slots, bug #450004
DEPEND="${RDEPEND}
	>=app-text/gnome-doc-utils-0.9
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
	java? ( >=virtual/jdk-1.6 )
	vala? ( $(vala_depend) )
"

# FIXME: lots of tests failing. Check if they still fail in 5.1.2
# firebird support bindist-restricted because it is not GPL compatible
RESTRICT="
	test
	firebird? ( bindist )
"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	use reports && python-single-r1_pkg_setup
}

src_prepare() {
	# Fix compilation with -Werror=format-security (from 'master')
	epatch "${FILESDIR}"/${PN}-5.2.4-format-security.patch

	# Support JRE 1.8 (from Fedora)
	epatch "${FILESDIR}"/${PN}-5.2.4-jre18.patch

	use berkdb && append-cppflags "-I$(db_includedir)"

	use reports ||
		sed -e '/SUBDIRS =/ s/trml2html//' \
			-e '/SUBDIRS =/ s/trml2pdf//' \
			-i libgda-report/RML/Makefile.{am,in} || die

	# Prevent file collisions with libgda:4
	epatch "${FILESDIR}/${PN}-4.99.1-gda-browser-doc-collision.patch"
	epatch "${FILESDIR}/${PN}-4.99.1-control-center-icon-collision.patch"
	# Move files with mv (since epatch can't handle rename diffs) and
	# update pre-generated gtk-doc files (for non-git versions of libgda)
	local f
	for f in tools/browser/doc/gda-browser* ; do
		mv ${f} ${f/gda-browser/gda-browser-5.0} || die "mv ${f} failed"
	done
	for f in tools/browser/doc/html/gda-browser.devhelp* ; do
		sed -e 's:name="gda-browser":name="gda-browser-5.0":' \
			-i ${f} || die "sed ${f} failed"
		mv ${f} ${f/gda-browser/gda-browser-5.0} || die "mv ${f} failed"
	done
	for f in control-center/data/*_gda-control-center.png ; do
		mv ${f} ${f/_gda-control-center.png/_gda-control-center-5.0.png} ||
			die "mv ${f} failed"
	done

	eautoreconf
	gnome2_src_prepare
	java-pkg-opt-2_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local myconf=( )
	if use introspection ; then
		myconf+=( $(use_enable gtk gdaui-gi) )
	else:
		myconf+=( --disable-gdaui-gi )
	fi
	if use vala ; then
		myconf+=( $(use_enable gtk gdaui-vala) )
	else
		myconf+=( --disable-gdaui-vala )
	fi

	gnome2_src_configure \
		--with-help \
		--disable-default-binary \
		--disable-static \
		--enable-system-sqlite \
		$(use_with berkdb bdb /usr) \
		$(use_with canvas goocanvas) \
		$(use_with firebird firebird /usr) \
		$(use_with gnome-keyring libsecret) \
		$(use_with graphviz) \
		$(use_with gtk ui) \
		$(use_with http libsoup) \
		$(use_enable introspection) \
		$(use_enable introspection gda-gi) \
		"$(use_with java java $JAVA_HOME)" \
		$(use_enable json) \
		$(use_with ldap) \
		$(use_with mdb mdb /usr) \
		$(use_with mysql mysql /usr) \
		$(use_with oci8 oracle) \
		$(use_with postgres postgres /usr) \
		$(use_enable ssl crypto) \
		$(use_with sourceview gtksourceview) \
		$(use_enable vala) \
		$(use_enable vala vala-extensions) \
		${myconf[@]}
}

pkg_preinst() {
	gnome2_pkg_preinst
	java-pkg-opt-2_pkg_preinst
}

src_install() {
	gnome2_src_install
	if use reports; then
		for t in trml2{html,pdf}; do
			python_scriptinto /usr/share/libgda-5.0/gda_${t}
			python_doscript libgda-report/RML/${t}/${t}.py
		done
	fi
}
