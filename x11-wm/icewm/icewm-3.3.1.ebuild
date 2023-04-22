# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools unpacker

DESCRIPTION="Ice Window Manager with Themes"
HOMEPAGE="https://ice-wm.org/ https://github.com/ice-wm/icewm"
LICENSE="GPL-2"
SRC_URI="https://github.com/ice-wm/icewm/releases/download/${PV}/${P}.tar.lz"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE="+alsa ao bidi debug +gdk-pixbuf imlib nls truetype xinerama"

# Tests broken in all versions, patches welcome, bug #323907, #389533
RESTRICT="test"

REQUIRED_USE="|| ( alsa ao )"
#?? ( gdk-pixbuf imlib )

#fix for icewm preversion package names
S="${WORKDIR}/${P/_}"

# These are the core dependencies of icewm.
# Look into configure.ac and search for PKG_CHECK_MODULES([CORE]
CORE_DEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
"

RDEPEND="
	${CORE_DEPEND}
	dev-libs/glib:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXrandr
	alsa? (
		media-libs/alsa-lib
		media-libs/libsndfile[alsa]
	)
	ao? (
		media-libs/libao
		media-libs/libsndfile
	)
	bidi? ( dev-libs/fribidi )
	gdk-pixbuf? (
		x11-libs/gdk-pixbuf-xlib
		>=x11-libs/gdk-pixbuf-2.42.0:2
	)
	!gdk-pixbuf? (
		imlib? (
			gnome-base/librsvg:2
			media-libs/imlib2
		)
		!imlib? (
			media-libs/libpng:0=
			media-libs/libjpeg-turbo:=
		)
	)
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	gdk-pixbuf? ( gnome-base/librsvg:2 )
"
BDEPEND="
	$(unpacker_src_uri_depends)
	app-text/asciidoc
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.19.8 )
"

pkg_pretend() {
	if use gdk-pixbuf && use imlib ; then
		einfo 'Conflicting USE flags have been enabled:'
		einfo '"gdk-pixbuf" and "imlib" exclude each other!'
		einfo 'Using "gdk-pixbuf".'
	fi
}

src_prepare() {
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
		--enable-logevents
		--enable-xrandr
		--with-cfgdir="${EPREFIX}"/etc/icewm
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		--with-icesound="${icesound}"
		--with-libdir="${EPREFIX}"/usr/share/icewm
		$(use_enable bidi fribidi)
		$(use_enable debug)
		$(use_enable debug logevents)
		$(use_enable gdk-pixbuf)
		$(use_enable imlib imlib2)
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

	econf "${myconf[@]}"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README.md TODO VERSION )

	default

	docinto html
	dodoc doc/icewm.html
	dodoc man/*.html

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/icewm"
}
