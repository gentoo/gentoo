# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils xdg-utils gnome2-utils versionator

MY_PN=${PN}-gaf
MY_P=${MY_PN}-${PV}

DESCRIPTION="GPL Electronic Design Automation (gEDA):gaf core package"
HOMEPAGE="http://wiki.geda-project.org/geda:gaf"
SRC_URI="http://ftp.geda-project.org/${MY_PN}/unstable/v$(get_version_component_range 1-2)/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug doc examples nls stroke threads"

CDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/pango
	>=x11-libs/cairo-1.2.0
	x11-libs/gdk-pixbuf
	>=dev-scheme/guile-2.0.0
	nls? ( virtual/libintl )
	stroke? ( >=dev-libs/libstroke-0.5.1 )"

DEPEND="${CDEPEND}
	sys-apps/groff
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.16 )"

RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS NEWS README"

PATCHES=( "${FILESDIR}"/${P}-guile-2.2.patch )

src_prepare() {
	default

	if ! use doc ; then
		sed -i -e '/^SUBDIRS = /s/docs//' Makefile.in || die
	fi
	if ! use examples ; then
		sed -i -e 's/\texamples$//' Makefile.in || die
	fi

	# add missing GIO_LIB Bug #684870
	sed -i -e 's/gsymcheck_LDFLAGS =/gsymcheck_LDFLAGS = $(GIO_LIBS)/' \
		gsymcheck/src/Makefile.am || die

	sed -i -e 's/gnetlist_LDFLAGS =/gnetlist_LDFLAGS = $(GIO_LIBS)/' \
		gnetlist/src/Makefile.am || die

	sed -i -e 's/gschlas_LDFLAGS =/gschlas_LDFLAGS = $(GIO_LIBS)/' \
		utils/gschlas/Makefile.am || die

	sed -i -e 's/sarlacc_schem_LDFLAGS =/sarlacc_schem_LDFLAGS = $(GIO_LIBS)/' \
		contrib/sarlacc_schem/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable threads threads posix) \
		$(use_with stroke libstroke) \
		$(use_enable nls) \
		$(use_enable debug assert) \
		--disable-doxygen \
		--disable-rpath \
		--disable-update-xdg-database
}

src_test() {
	emake -j1 check
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
