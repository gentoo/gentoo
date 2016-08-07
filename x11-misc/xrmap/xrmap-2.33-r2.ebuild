# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

FLAGS_VER=2.9
ANTHEMS_VER=1.3
HYMNS_VER=1.4
FACTBOOK_VER=2008
DESCRIPTION="X client for generating images of Earth and manipulating CIA World data bank"
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
	virtual/jpeg:0
	>=media-libs/libpng-1.4:0
	sys-libs/zlib"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	app-text/gv
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick-compat] )
	sys-apps/less
	media-sound/timidity++"
DEPEND="${CDEPEND}
	x11-proto/xproto
	>=sys-apps/sed-4"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.kit.patch
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${P}-parallel-make.patch
	"${FILESDIR}"/${P}-libpng15.patch
	"${FILESDIR}"/${P}-zlib.patch
)

src_prepare() {
	default

	tc-export CC

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
	# bug #520890
	sed -i -e "s:TLIBS = -L/usr/lib -ltermcap:TLIBS = $($(tc-getPKG_CONFIG) --libs ncurses):g" editkit/Makefile.kit || die
}

src_compile() {
	emake HTML_VIEWER="xdg-open"
	emake -C tools
	emake -C tools/jpd2else
	emake -C tools/cbd2else
}

src_install() {
	dobin xrmap tools/preproc tools/jpd2else/jpd2else tools/cbd2else/cbd2else earthview/earthview

	dodir /etc/xrmap
	insinto /etc/xrmap
	doins Xrmaprc

	dodoc CHANGES README TODO tools/cbd2else/README.cbd tools/jpd2else/README.jpd tools/rez2else/README.rez
	newman xrmap.man xrmap.1

	mv "${WORKDIR}"/hymns-${HYMNS_VER} hymns || die
	mv "${WORKDIR}"/anthems-${ANTHEMS_VER} anthems || die
	dodir /usr/share/${PN}/
	insinto /usr/share/${PN}
	doins -r i18n hymns anthems Locations pixmaps "${WORKDIR}"/{factbook,flags,earthdata,CIA_WDB2.jpd}
}
