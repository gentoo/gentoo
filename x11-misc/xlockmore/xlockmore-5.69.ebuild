# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic pam

DESCRIPTION="Just another screensaver application for X"
HOMEPAGE="https://www.sillycycle.com/xlockmore.html"
SRC_URI="
	https://www.sillycycle.com/xlock/${P/_alpha/ALPHA}.tar.xz
	https://www.sillycycle.com/xlock/recent-releases/${P/_alpha/ALPHA}.tar.xz
"
S="${WORKDIR}/${P/_alpha/ALPHA}"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="crypt debug gtk imagemagick motif nas opengl pam truetype xinerama xlockrc vtlock"

REQUIRED_USE="
	|| ( crypt pam )
	pam? ( !xlockrc )
	xlockrc? ( !pam )
"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	gtk? ( x11-libs/gtk+:2 )
	imagemagick? ( media-gfx/imagemagick:= )
	motif? ( >=x11-libs/motif-2.3:0 )
	nas? ( media-libs/nas )
	opengl? (
		virtual/opengl
		virtual/glu
		truetype? ( >=media-libs/ftgl-2.1.3_rc5 )
	)
	pam? ( sys-libs/pam )
	truetype? ( media-libs/freetype:2 )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

PATCHES=(
	"${FILESDIR}"/${PN}-5.46-freetype261.patch
	"${FILESDIR}"/${PN}-5.47-CXX.patch
	"${FILESDIR}"/${PN}-5.47-strip.patch
	#"${FILESDIR}"/${PN}-5.64_alpha0-LDFLAGS.patch
)

src_prepare() {
	default

	sed -i \
		-e '/XLOCKLIBPATHS="-L/d' \
		-e '/XMLOCKLIBPATHS="-L/d' \
		-e 's|/lib|'"${EPREFIX}/$(get_libdir)"'|g' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	local myconf=()

	if use opengl && use truetype; then
		append-cppflags -DFTGL213

		myconf=( --with-ftgl )
	else
		myconf=( --without-ftgl )
	fi

	myconf+=(
		$(use_enable pam)
		$(use_enable xlockrc)
		$(use_enable vtlock)
		$(use_with crypt)
		$(use_with debug editres)
		$(use_with gtk gtk2)
		$(use_with imagemagick magick)
		$(use_with motif)
		$(use_with nas)
		$(use_with opengl mesa)
		$(use_with opengl)
		$(use_with truetype freetype)
		$(use_with truetype ttf)
		$(use_with xinerama)
		--disable-mb
		--enable-appdefaultdir=/usr/share/X11/app-defaults
		--enable-syslog
		--enable-vtlock
		--without-esound
		--without-gtk
	)

	econf "${myconf[@]}"
}

src_install() {
	local DOCS=( README docs/{3d.howto,cell_automata,HACKERS.GUIDE,Purify,Revisions,TODO} )
	default

	if use pam; then
		pamd_mimic_system xlock auth
		fperms 755 /usr/bin/xlock
	else
		fperms 4755 /usr/bin/xlock
	fi

	docinto html
	dodoc docs/xlock.html
}
