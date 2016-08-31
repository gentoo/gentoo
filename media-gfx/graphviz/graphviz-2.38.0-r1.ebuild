# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils flag-o-matic java-pkg-opt-2 multilib python-single-r1 qmake-utils

DESCRIPTION="Open Source Graph Visualization Software"
HOMEPAGE="http://www.graphviz.org/"
SRC_URI="http://www.graphviz.org/pub/graphviz/stable/SOURCES/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="+cairo devil doc examples gdk-pixbuf gtk gts guile java lasi nls pdf perl postscript python qt4 ruby svg static-libs tcl X elibc_FreeBSD"

# Requires ksh
RESTRICT="test"

RDEPEND="
	sys-libs/zlib
	>=dev-libs/expat-2
	>=dev-libs/glib-2.11.1:2
	dev-libs/libltdl:0
	>=media-libs/fontconfig-2.3.95
	>=media-libs/freetype-2.1.10
	>=media-libs/gd-2.0.34:=[fontconfig,jpeg,png,truetype,zlib]
	>=media-libs/libpng-1.2:0
	!<=sci-chemistry/cluster-1.3.081231
	virtual/jpeg:0
	virtual/libiconv
	X? (
		x11-libs/libXaw
		x11-libs/libX11
		x11-libs/libXmu
		x11-libs/libXpm
		x11-libs/libXt
	)
	cairo?	(
		>=x11-libs/pango-1.12
		>=x11-libs/cairo-1.1.10[svg]
	)
	devil?	( media-libs/devil[png,jpeg] )
	postscript? ( app-text/ghostscript-gpl )
	gtk?	( x11-libs/gtk+:2 )
	gts?	( sci-libs/gts )
	lasi?	( media-libs/lasi )
	pdf?	( app-text/poppler )
	perl?   ( dev-lang/perl:= )
	python?	( ${PYTHON_DEPS} )
	qt4?	(
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	ruby?	( dev-lang/ruby:* )
	svg?	( gnome-base/librsvg )
	tcl?	( >=dev-lang/tcl-8.3:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	sys-devel/libtool
	guile?	( dev-scheme/guile dev-lang/swig )
	java?	( >=virtual/jdk-1.5 dev-lang/swig )
	nls?	( >=sys-devel/gettext-0.14.5 )
	perl?	( dev-lang/swig )
	python?	( dev-lang/swig )
	ruby?	( dev-lang/swig )
	tcl?	( dev-lang/swig )"
REQUIRED_USE="
	!cairo? ( !X !gtk !postscript !lasi )
	python? ( ${PYTHON_REQUIRED_USE} )"

# Dependency description / Maintainer-Info:

# Rendering is done via the following plugins (/plugins):
# - core, dot_layout, neato_layout, gd , dot
#   the ones which are always compiled in, depend on zlib, gd
# - gtk
#   Directly depends on gtk-2.
#   needs 'pangocairo' enabled in graphviz configuration
#   gtk-2 depends on pango, cairo and libX11 directly.
# - gdk-pixbuf
#   Disabled, GTK-1 junk.
# - glitz
#   Disabled, no particular reason
#   needs 'pangocairo' enabled in graphviz configuration
# - ming
#   flash plugin via -Tswf requires media-libs/ming-0.4. Disabled as it's
#   incomplete.
# - cairo/pango:
#   Needs pango for text layout, uses cairo methods to draw stuff
# - xlib:
#   needs cairo+pango,
#   can make use of gnomeui and inotify support (??? unsure),
#   needs libXaw for UI
#   UI also links directly against libX11, libXmu, and libXt
#   and uses libXpm if available so we make sure it always is

# There can be swig-generated bindings for the following languages (/tclpkg/gv):
# - c-sharp (disabled)
# - scheme (enabled via guile) ... no longer broken on ~x86
# - io (disabled)
# - java (enabled via java) *2
# - lua (enabled via lua)
# - ocaml (enabled via ocaml)
# - perl (enabled via perl) *1
# - php (enabled via php) *2
# - python (enabled via python) *1
# - ruby (enabled via ruby) *1
# - tcl (enabled via tcl)
# *1 = The ${P}-bindings.patch takes care that those bindings are installed to the right location
# *2 = Those bindings don't build because the paths for the headers/libs aren't
#      detected correctly and/or the options passed to swig are wrong (-php instead of -php4/5)

# There are several other tools in /tclpkg:
# gdtclft, tcldot, tclhandle, tclpathplan, tclstubs ; enabled with: --with-tcl
# tkspline, tkstubs ; enabled with: --with-tk

# And the commands (/cmd):
# - dot, dotty, gvedit, gvpr, lefty, lneato, smyrna, tools/* :)
#   sci-libs/gts can be used for some of these
# - lefty:
#   needs Xaw and X to build
# - gvedit (via 'qt4'):
#   based on ./configure it needs qt-core and qt-gui only
# - smyrna : experimental opengl front-end (via 'smyrna')
#   currently disabled -- it segfaults a lot
#   needs x11-libs/gtkglext, gnome-base/libglade, media-libs/freeglut
#   sci-libs/gts, x11-libs/gtk.  Also needs 'gtk','glade','glut','gts' and 'png'
#   with flags enabled at configure time

pkg_setup() {
	use python && python-single-r1_pkg_setup

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.34.0-Xaw-configure.patch \
		"${FILESDIR}"/${PN}-2.34.0-dot-pangocairo-link.patch \
		"${FILESDIR}"/${PN}-2.38.0-ghostscript-9.18.patch

	# ToDo: Do the same thing for examples and/or
	#       write a patch for a configuration-option
	#       and send it to upstream
	# note - the longer sed expression removes multi-line assignments that are extended via '\'
	if ! use doc ; then
		find . -iname Makefile.am \
			| xargs sed -i -e '/^\(html\|pdf\)_DATA.*\\[[:space:]]*$/{:m;N;s/\\\n//;tm;d}' \
				-e '/^\(html\|pdf\)_DATA/d' || die
	fi

	# This is an old version of libtool
	# use the ./configure option to exclude its use, and
	# delete the dir since we don't need to eautoreconf it
	rm -rf libltdl || die

	# no nls, no gettext, no iconv macro, so disable it
	use nls || { sed -i -e '/^AM_ICONV/d' configure.ac || die; }

	# Nuke the dead symlinks for the bindings
	sed -i -e '/$(pkgluadir)/d' tclpkg/gv/Makefile.am || die

	# replace the whitespace with tabs
	sed -i -e 's:  :\t:g' doc/info/Makefile.am || die

	# use correct version of qmake. bug #567236
	sed -i -e "/AC_CHECK_PROGS(QMAKE/a AC_SUBST(QMAKE,$(qt4_get_bindir)/qmake)" configure.ac || die

	# workaround for http://www.graphviz.org/mantisbt/view.php?id=1895
	use elibc_FreeBSD && append-flags $(test-flags -fno-builtin-sincos)

	use java && append-cppflags $(java-pkg_get-jni-cflags)

	eautoreconf
}

src_configure() {
	# libtool file collision, bug 276609
	local myconf="--without-included-ltdl --disable-ltdl-install"

	myconf="${myconf}
		$(use_with cairo pangocairo)
		$(use_with devil)
		$(use_with gtk)
		$(use_with gts)
		$(use_with qt4 qt)
		$(use_with lasi)
		$(use_with pdf poppler)
		$(use_with postscript ghostscript)
		$(use_with svg rsvg)
		$(use_with X x)
		$(use_with X xaw)
		$(use_with X lefty)
		--with-digcola
		--with-fontconfig
		--with-freetype2
		--with-ipsepcola
		--with-libgd
		--with-sfdp
		$(use_enable gdk-pixbuf)
		--without-ming"

	# new/experimental features, to be tested, disable for now
	myconf="${myconf}
		--with-cgraph
		--without-glitz
		--without-ipsepcola
		--without-smyrna
		--without-visio"

	# Bindings:
	myconf="${myconf}
		$(use_enable guile)
		--disable-io
		$(use_enable java)
		--disable-lua
		--disable-ocaml
		$(use_enable perl)
		--disable-php
		$(use_enable python)
		--disable-r
		$(use_enable ruby)
		--disable-sharp
		$(use_enable tcl)"

	econf \
		--enable-ltdl \
		--disable-silent-rules \
		$(use_enable static-libs static) \
		${myconf}
}

src_install() {
	sed -i -e "s:htmldir:htmlinfodir:g" doc/info/Makefile || die

	emake DESTDIR="${D}" \
		txtdir="${EPREFIX}"/usr/share/doc/${PF} \
		htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		htmlinfodir="${EPREFIX}"/usr/share/doc/${PF}/html/info \
		pdfdir="${EPREFIX}"/usr/share/doc/${PF}/pdf \
		pkgconfigdir="${EPREFIX}"/usr/$(get_libdir)/pkgconfig \
		install

	use examples || rm -rf "${ED}"/usr/share/graphviz/demo

	use static-libs || find "${ED}" -name '*.la' -exec rm -f {} +

	dodoc AUTHORS ChangeLog NEWS README

	use python && python_optimize \
		"${D}$(python_get_sitedir)" \
		"${D}/usr/$(get_libdir)/graphviz/python"
}

pkg_postinst() {
	# This actually works if --enable-ltdl is passed
	# to configure
	dot -c
}

pkg_postrm() {
	# Remove cruft, bug #547344
	rm -f "${EROOT}usr/lib/graphviz/config{,6}"
}
