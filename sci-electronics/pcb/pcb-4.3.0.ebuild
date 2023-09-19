# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs virtualx xdg

DESCRIPTION="GPL Electronic Design Automation: Printed Circuit Board editor"
HOMEPAGE="http://pcb.geda-project.org/"
SRC_URI="mirror://sourceforge/pcb/pcb/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus doc gcode gif gsvit gui jpeg m4lib-png nelma png test tk toporouter"
# toporouter-output USE flag removed, there seems to be no result
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	sci-electronics/electronics-menu
	gif? ( media-libs/gd )
	gsvit? ( media-libs/gd[png] )
	gui? (
		x11-libs/gtk+:2
		x11-libs/pango
		dbus? ( sys-apps/dbus )
	)
	jpeg? ( media-libs/gd[jpeg] )
	nelma? ( media-libs/gd[png] )
	gcode? ( media-libs/gd[png] )
	virtual/libintl
	png? ( media-libs/gd[png] )
	m4lib-png? ( media-libs/gd[png] )
	tk? ( >=dev-lang/tk-8:0 )"
#toporouter-output? ( x11-libs/cairo )

DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext
	test? (
		sci-electronics/gerbv
		virtual/imagemagick-tools
	)"

PATCHES=( "${FILESDIR}"/${PN}-4.2.2-fix-autotools.patch )

src_prepare() {
	default
	eautoreconf

	# tests are unconditional, even in the known presence of missing/disabled
	# features, so we have to remove feature tests ourselves.
	if ! use gcode; then
		sed -i '/^hid_gcode/d' tests/tests.list || die
	fi
	if ! use gsvit; then
		sed -i '/^hid_gsvit/d' tests/tests.list || die
	fi
	if ! use nelma; then
		sed -i '/^hid_nelma/d' tests/tests.list || die
	fi
	if ! use png; then
		sed -i '/^hid_png/d' tests/tests.list || die
	fi
	if ! use gif; then
		sed -i '/^hid_png10[[:digit:]]/d' tests/tests.list || die
	fi
	if ! use jpeg; then
		sed -i '/^hid_png20[[:digit:]]/d' tests/tests.list || die
	fi
}

src_configure() {
	local exporters=( bom gerber ps ipcd356 )
	if use png || use jpeg || use gif; then
		exporters+=( png )
	fi
	use gcode && exporters+=( gcode )
	use gsvit && exporters+=( gsvit )
	use nelma && exporters+=( nelma )
	use tk || export WISH="${EPREFIX}/bin/true"

	# toporouter-output USE flag removed, seems to do nothing
	# opengl disabled unconditionally, due to requiring EOL gtkglext
	econf \
		--disable-gl \
		--disable-rpath \
		--disable-toporouter-output \
		--disable-update-mime-database \
		--disable-update-desktop-database \
		--disable-xrender \
		--enable-nls \
		$(use_enable doc) \
		$(use_enable gif) \
		$(use_enable jpeg) \
		$(use_enable png) \
		$(use_enable m4lib-png) \
		$(use_enable toporouter) \
		$(use_enable gui dbus $(usex dbus yes no)) \
		--with-gui=$(usex gui gtk batch) \
		--with-exporters="${exporters[*]}"
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_test() {
	virtx emake check
}
