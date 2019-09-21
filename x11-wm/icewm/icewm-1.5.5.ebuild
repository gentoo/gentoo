# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Ice Window Manager with Themes"
HOMEPAGE="https://ice-wm.org/ https://github.com/ice-wm/icewm"
LICENSE="GPL-2"
SRC_URI="https://github.com/ice-wm/icewm/releases/download/${PV}/${P}.tar.xz"

SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="+alsa ao bidi debug nls truetype uclibc xinerama"

# Tests broken in all versions, patches welcome, bug #323907, #389533
RESTRICT="test"

REQUIRED_USE="|| ( alsa ao )"

#fix for icewm preversion package names
S="${WORKDIR}/${P/_}"

RDEPEND="
	media-libs/fontconfig
	x11-libs/gdk-pixbuf:2[X]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXrender
	alsa? (
		media-libs/alsa-lib
		media-libs/libsndfile[alsa]
	)
	ao? (
		media-libs/libao
		media-libs/libsndfile
	)
	bidi? ( dev-libs/fribidi )
	truetype? ( x11-libs/libXext )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	gnome-base/librsvg
	x11-base/xorg-proto
	truetype? ( >=media-libs/freetype-2.0.9 )
"

BDEPEND="
	app-text/asciidoc
	nls? ( >=sys-devel/gettext-0.19.6 )
"

src_prepare() {
	# Fix bug #486710 - TODO: Still needed?
	#use uclibc && PATCHES+=( "${FILESDIR}/${PN}-1.3.8-uclibc.patch" )

	default
	eautoreconf
}

src_configure() {
	local icesound
	if use alsa && use ao ; then
		icesound="alsa,ao"
	elif use alsa ; then
		icesound="alsa"
	elif use ao ; then
		icesound="ao"
	fi

	local myconf=(
		--enable-gdk-pixbuf
		--enable-logevents
		--enable-xrandr
		--enable-xrender
		--with-cfgdir=/etc/icewm
		--with-docdir=/usr/share/doc/${PF}/html
		--with-icesound="${icesound}"
		--with-libdir=/usr/share/icewm
		$(use_enable bidi fribidi)
		$(use_enable debug)
		$(use_enable nls i18n)
		$(use_enable nls)
		$(use_enable xinerama)
	)
	if use truetype ; then
		myconf+=(
			--enable-shape
		)
	else
		myconf+=(
			--disable-xfreetype
			--enable-corefonts
		)
	fi

	CXXFLAGS="${CXXFLAGS}" econf "${myconf[@]}"

	sed -i "s:/icewm-\$(VERSION)::" src/Makefile || die
	sed -i "s:ungif:gif:" src/Makefile || die "libungif fix failed"
}

src_install(){
	local DOCS=( AUTHORS ChangeLog NEWS README.md TODO VERSION )

	default

	docinto html
	dodoc doc/icewm.html
	dodoc man/*.html

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/icewm"
}
