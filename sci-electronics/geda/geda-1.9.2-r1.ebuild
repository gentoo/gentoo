# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

MY_PN=${PN}-gaf
MY_P=${MY_PN}-${PV}

DESCRIPTION="GPL Electronic Design Automation (gEDA):gaf core package"
HOMEPAGE="http://wiki.geda-project.org/geda:gaf"
SRC_URI="http://ftp.geda-project.org/${MY_PN}/unstable/v$(ver_cut 1-2)/${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc examples nls stroke threads"

RDEPEND="
	dev-libs/glib:2
	dev-scheme/guile
	sci-electronics/electronics-menu
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/pango
	nls? ( virtual/libintl )
	stroke? ( dev-libs/libstroke )"

DEPEND="${RDEPEND}
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info"
BDEPEND="
	sys-apps/groff
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-guile-2.2.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

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

	rm docs/wiki/media/geda/gsch2pcb-libs.tar.gz || die

	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-doxygen
		--disable-rpath
		--disable-update-xdg-database
		$(use_enable debug assert)
		$(use_enable nls)
		$(use_enable threads threads posix)
		$(use_with stroke libstroke)
	)

	econf "${myconf[@]}"
}

src_test() {
	emake -j1 check
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
