# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DEPEND="
	media-gfx/graphviz
	media-gfx/imagemagick
	virtual/latex-base
"
inherit autotools docs xdg

MY_PN=${PN}-gaf
MY_P=${MY_PN}-${PV}

DESCRIPTION="GPL Electronic Design Automation (gEDA):gaf core package"
HOMEPAGE="http://geda-project.org/ http://wiki.geda-project.org/geda:gaf"
SRC_URI="http://ftp.geda-project.org/${MY_PN}/stable/v$(ver_cut 1-2)/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="debug examples fam nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/glib:2
	dev-scheme/guile
	sci-electronics/electronics-menu
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango
	nls? ( virtual/libintl )
	fam? ( app-admin/gamin )
"

DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info"
BDEPEND="
	sys-apps/groff
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	# Xorn requires python2
	"${FILESDIR}/${P}-drop-xorn.patch"

	"${FILESDIR}/${PN}-1.10.2-fix-gtk-sheet.patch"
)

src_prepare() {
	default
	rm -r xorn || die

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
		gnetlist-legacy/src/Makefile.am || die

	sed -i -e 's/gschlas_LDFLAGS =/gschlas_LDFLAGS = $(GIO_LIBS)/' \
		utils/gschlas/Makefile.am || die

	sed -i -e 's/sarlacc_schem_LDFLAGS =/sarlacc_schem_LDFLAGS = $(GIO_LIBS)/' \
		contrib/sarlacc_schem/Makefile.am || die

	# remove compressed files, compressed by portage in install phase
	rm docs/wiki/media/geda/gsch2pcb-libs.tar.gz || die
	rm docs/wiki/media/geda/pcb_plugin_template.tar.gz || die
	rm docs/wiki/media/pcb/plugin_debug_window.tar.gz || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-rpath
		--disable-update-xdg-database
		$(use_enable doc doxygen)
		$(use_enable debug assert)
		$(use_enable nls)
		$(use_with fam libfam)
	)

	econf "${myconf[@]}"
}
