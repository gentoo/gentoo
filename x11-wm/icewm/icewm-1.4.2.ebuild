# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Ice Window Manager with Themes"
HOMEPAGE="http://www.icewm.org/ https://github.com/bbidulock/icewm"
LICENSE="GPL-2"
SRC_URI="https://github.com/bbidulock/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="bidi debug doc minimal nls truetype uclibc xinerama"

# Tests broken in all versions, patches welcome, bug #323907, #389533
RESTRICT="test"

#fix for icewm preversion package names
S="${WORKDIR}/${P/_}"

RDEPEND="
	media-libs/fontconfig
	x11-libs/gdk-pixbuf:2[X]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	bidi? ( dev-libs/fribidi )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	>=sys-apps/sed-4
	x11-proto/xextproto
	x11-proto/xproto
	doc? ( app-text/linuxdoc-tools )
	nls? ( >=sys-devel/gettext-0.19.6 )
	truetype? ( >=media-libs/freetype-2.0.9 )
	xinerama? ( x11-proto/xineramaproto )
"

pkg_setup() {
	if use truetype && use minimal ; then
		ewarn "You have both 'truetype' and 'minimal' use flags enabled."
		ewarn "If you really want a minimal install, you will have to turn off"
		ewarn "the truetype flag for this package."
	fi
}

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.10-menu.patch
)

src_prepare() {
	# Fix bug #486710
	use uclibc && PATCHES+=( "${FILESDIR}/${PN}-1.3.8-uclibc.patch" )

	default

	if ! use doc ; then
		sed '/^SUBDIRS =/s@ doc@@' -i Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-menus-gnome2
		--with-libdir=/usr/share/icewm
		--with-cfgdir=/etc/icewm
		--with-docdir=/usr/share/doc/${PF}/html
		$(use_enable bidi fribidi)
		$(use_enable debug)
		$(use_enable nls i18n)
		$(use_enable nls)
		$(use_enable xinerama)
	)
	if use truetype ; then
		myconf+=(
			--enable-gradients
			--enable-shape
			--enable-shaped-decorations
		)
	else
		myconf+=(
			--disable-xfreetype
			--enable-corefonts
			$(use_enable minimal lite)
		)
	fi

	CXXFLAGS="${CXXFLAGS}" econf "${myconf[@]}"

	sed -i "s:/icewm-\$(VERSION)::" src/Makefile || die
	sed -i "s:ungif:gif:" src/Makefile || die "libungif fix failed"
}

src_install(){
	local DOCS=( AUTHORS BUGS CHANGES PLATFORMS README.md TODO VERSION )

	default

	if ! use doc ; then
		cp doc/${PN}.man "${T}"/${PN}.1 || die
		doman "${T}"/${PN}.1
	fi

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/icewm"
}
