# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

FLAGS_VER=2.9
ANTHEMS_VER=1.3
HYMNS_VER=1.4
FACTBOOK_VER=2008
DESCRIPTION="a X client for generating images of the Earth and manipulating the CIA World data bank"
HOMEPAGE="http://frmas.free.fr/li_1.htm#_Xrmap_"
SRC_URI="ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/${P}.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/data/factbook_html_${FACTBOOK_VER}.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/data/anthems-${ANTHEMS_VER}.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/data/flags-${FLAGS_VER}-xpm_150.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/data/hymns-${HYMNS_VER}.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/${PN}/data/earthdata_low_res.tar.bz2
		 ftp://ftp.ac-grenoble.fr/ge/geosciences/CIA_WDB2.jpd.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

CDEPEND="x11-libs/libX11
	x11-libs/libXpm
	virtual/jpeg
	>=media-libs/libpng-1.4
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	app-text/gv
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )
	sys-apps/less
	media-sound/timidity++"
DEPEND="${CDEPEND}
	x11-proto/xproto
	>=sys-apps/sed-4"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.kit.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-parallel-make.patch \
		"${FILESDIR}"/${P}-libpng15.patch \
		"${FILESDIR}"/${P}-zlib.patch

	sed  -e 's,^\(X11DIR=\).*,\1/usr/,g' \
		 -e 's,^\(EDITOR=\).*,\1less,g'   \
		 -e 's,^\(SHAREDIR=\).*,\1/usr/share/xrmap,g' \
		 -e 's,^\(CCOPTIONS=\)-O6 -g,\1${CFLAGS},g' \
		 -e 's,^\(LDOPTIONS=\)-O6 -g,\1${LDFLAGS},g' \
		 -e 's,gcc,$(CC),' \
			Makefile.noimake > Makefile || die
	sed -i 's,^\(#define DEFAULT_JPD_FILE \"/usr/share/\),\1x,g' \
		tools/jpd2else/jpd2else.c || die
	sed -i -e 's,^\(#define RCFILE \)SHAREDIR\",\1\"/etc/xrmap,g'  \
		   -e 's,^\(#define SHAREDIR \"/usr/share/\),\1x,g' xrmap.h || die
	# bug #323065
	sed -i "/^image.o/s/image.o:/& numdefs.h/" Makefile || die
	# Respect CFLAGS, LDFLAGS, CC
	sed -i -e 's,cc,$(CC) $(CFLAGS) $(LDFLAGS),' tools/Makefile || die
	sed -i -e 's,gcc,$(CC) $(CFLAGS) $(LDFLAGS),' \
		tools/jpd2else/Makefile tools/cbd2else/Makefile \
		earthview/Makefile editkit/Makefile.kit || die
	# Fix implicit decl of strlen
	sed -i -e '3 i #include <string.h>' tools/preproc.c || die
	# Fix array subscript below bounds (Eliminates unnecessary cast to char)
	sed -i -e '2495 s/(char)//' xrmap.c || die
	# Fix datadir for earthview
	sed -i -e 's,^DATADIR=.*$,DATADIR=/usr/share/xrmap/earthdata,' earthview/Makefile || die
}

src_compile() {
	emake HTML_VIEWER="xdg-open" || die
	emake -C tools || die
	emake -C tools/jpd2else || die
	emake -C tools/cbd2else || die
}

src_install() {
	dobin xrmap tools/preproc tools/jpd2else/jpd2else tools/cbd2else/cbd2else \
		earthview/earthview || die
	dodir /etc/xrmap  || die
	insinto /etc/xrmap
	doins Xrmaprc  || die
	dodoc CHANGES README TODO tools/cbd2else/README.cbd tools/jpd2else/README.jpd tools/rez2else/README.rez || die
	newman xrmap.man xrmap.1 || die "newman failed"
	mv "${WORKDIR}"/hymns-${HYMNS_VER} hymns || die
	mv "${WORKDIR}"/anthems-${ANTHEMS_VER} anthems || die
	dodir /usr/share/${PN}/ || die
	insinto /usr/share/${PN}
	doins -r i18n hymns anthems Locations pixmaps \
		"${WORKDIR}"/{factbook,flags,earthdata,CIA_WDB2.jpd}  || die
}
