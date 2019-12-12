# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools eutils xdg-utils gnome2-utils toolchain-funcs

DESCRIPTION="GPL Electronic Design Automation: Printed Circuit Board editor"
HOMEPAGE="http://pcb.geda-project.org/"
SRC_URI="mirror://sourceforge/pcb/pcb/${P/0_p/}/${P/0_p/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-macos"
IUSE="dbus debug doc gcode gif gtk jpeg m4lib-png motif nelma opengl png
test tk toporouter xrender"
# toporouter-output USE flag removed, there seems to be no result
RESTRICT="!test? ( test )"

CDEPEND="dev-libs/glib:2
	gif? ( >=media-libs/gd-2.0.23 )
	gtk? ( x11-libs/gtk+:2 x11-libs/pango
		x11-libs/gtkglext
		dbus? ( sys-apps/dbus ) )
	jpeg? ( >=media-libs/gd-2.0.23[jpeg] )
	motif? ( !gtk? (
		>=x11-libs/motif-2.3:0
		dbus? ( sys-apps/dbus )
		xrender? ( >=x11-libs/libXrender-0.9 ) ) )
	nelma? ( >=media-libs/gd-2.0.23[png] )
	opengl? ( virtual/opengl )
	gcode? ( >=media-libs/gd-2.0.23[png] )
	virtual/libintl
	png? ( >=media-libs/gd-2.0.23[png] )
	m4lib-png? ( >=media-libs/gd-2.0.23[png] )
	tk? ( >=dev-lang/tk-8:0 )"
#toporouter-output? ( x11-libs/cairo )

DEPEND="${CDEPEND}
	test? (
		sci-electronics/gerbv
		virtual/imagemagick-tools
	)
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext"

RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

DOCS="AUTHORS README NEWS ChangeLog"

S="${WORKDIR}/${P/0_p/}"

pkg_setup() {
	if use gtk && use motif; then
		elog "Can only build for GTK+ or Motif/Lesstif GUI. GTK+ has priority."
	fi
	if !(use gtk || use motif); then
		elog "Building without GUI, make sure you know what you are doing."
	fi
	if use dbus && !(use gtk || use motif); then
		elog "dbus needs GTK or Motif/Lesstif GUI. Try USE=-dbus or USE=gtk or USE=motif."
	fi
	if use opengl && !(use gtk); then
		elog "GL drawing needs GTK"
	fi
	if (use gtk || (! use gtk && ! use motif)) &&  (use xrender); then
		elog "The XRender extension is only usable with the Motif/Lesstif GUI."
	fi
}

src_prepare() {
	if use test; then
		# adapt the list of tests to run according to USE flag settings
		if ! use png; then
			sed -i '/^hid_png/d' tests/tests.list || die
		fi
		if ! use gcode; then
			sed -i '/^hid_gcode/d' tests/tests.list || die
		fi
	fi
	# Backport from upstream
	# http://git.geda-project.org/pcb/commit/?id=a34b40add60310a51780f359cc90d9c5ee75752c
	# (do not install static GTS library)
	sed -i -e 's/lib_LIBRARIES/noinst_LIBRARIES/' -e 's/include_HEADERS/noinst_HEADERS/' gts/Makefile.am || die

	# fix bad syntax in Makefile.am and configure.ac before running eautoreconf
	sed -i -e 's/:=/=/' Makefile.am || die
	epatch "${FILESDIR}"/${PN}-20110918-fix-config.diff
	eautoreconf
}

src_configure() {
	local myconf
	if use gtk ; then
		myconf="--with-gui=gtk $(use_enable dbus) $(use_enable opengl gl) --disable-xrender"
	elif use motif ; then
		myconf="--with-gui=lesstif $(use_enable dbus) $(use_enable xrender)"
	else
		myconf="--with-gui=batch --disable-xrender --disable-dbus"
	fi

	local exporters="bom gerber ps"
	if (use png || use jpeg || use gif) ; then
		exporters="${exporters} png"
	fi
	use nelma && exporters="${exporters} nelma"
	use gcode && exporters="${exporters} gcode"
	use tk || export WISH="${EPREFIX}/bin/true"

	econf \
		${myconf} \
		$(use_enable doc) \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable m4lib-png) \
		$(use_enable toporouter) \
		$(use_enable debug) \
		--enable-nls \
		--disable-toporouter-output \
		--with-exporters="${exporters}" \
		--disable-dependency-tracking \
		--disable-rpath \
		--disable-update-mime-database \
		--disable-update-desktop-database \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}
# toporouter-output USE flag removed, there seems to be no result
#		$(use_enable toporouter-output) \

src_compile() {
	emake AR="$(tc-getAR)"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
