# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WANT_AUTOMAKE="1.11"

inherit eutils flag-o-matic gnome2 autotools

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="http://www.shatters.net/celestia/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cairo gnome gtk nls pch theora threads"

RDEPEND="
	virtual/opengl
	virtual/jpeg:0
	media-libs/libpng:0=
	<dev-lang/lua-5.2:*
	gtk? ( !gnome? ( x11-libs/gtk+:2 >=x11-libs/gtkglext-1.0 ) )
	gnome? (
		x11-libs/gtk+:2
		>=x11-libs/gtkglext-1.0
		>=gnome-base/libgnomeui-2.0
	)
	!gtk? ( !gnome? ( media-libs/freeglut ) )
	cairo? ( x11-libs/cairo )
	theora? ( media-libs/libtheora )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	# Check for one for the following use flags to be set.
	if use gnome; then
		einfo "USE=\"gnome\" detected."
		USE_DESTDIR="1"
		CELESTIA_GUI="gnome"
	elif use gtk; then
		einfo "USE=\"gtk\" detected."
		CELESTIA_GUI="gtk"
	else
		ewarn "If you want to use the full gui, set USE=\"{gnome|gtk}\""
		ewarn "Defaulting to glut support (no GUI)."
		CELESTIA_GUI="glut"
	fi
}

src_prepare() {
	# make better desktop files
	epatch "${FILESDIR}"/${PN}-1.5.0-desktop.patch
	# add a ~/.celestia for extra directories
	epatch "${FILESDIR}"/${PN}-1.6.0-cfg.patch
	# fix missing includes for gcc-4.6
	epatch "${FILESDIR}"/${P}-gcc46.patch
	# missing zlib.h include with libpng15
	epatch "${FILESDIR}"/${P}-libpng15.patch \
		"${FILESDIR}"/${P}-linking.patch

	# gcc-47, #414015
	epatch "${FILESDIR}"/${P}-gcc47.patch

	# libpng16 #464764
	epatch "${FILESDIR}"/${P}-libpng16.patch

	# remove flags to let the user decide
	local
	for cf in -O2 -ffast-math \
		-fexpensive-optimizations \
		-fomit-frame-pointer; do
		sed -i \
			-e "s/${cf}//g" \
			configure.in admin/* || die "sed failed"
	done
	# remove an unused gconf macro killing autoconf when no gnome
	# (not needed without eautoreconf)
	if ! use gnome; then
		sed -i \
			-e '/AM_GCONF_SOURCE_2/d' \
			configure.in || die "sed failed"
	fi
	eautoreconf
	filter-flags "-funroll-loops -frerun-loop-opt"

	### This version of Celestia has a bug in the font rendering and
	### requires -fsigned-char. We should be able to force this flag
	### on all architectures. See bug #316573.
	append-flags "-fsigned-char"
}

src_configure() {
	# force lua in 1.6.1. seems to be inevitable
	econf \
		--disable-rpath \
		--with-${CELESTIA_GUI} \
		--with-lua \
		$(use_enable cairo) \
		$(use_enable threads threading) \
		$(use_enable nls) \
		$(use_enable pch) \
		$(use_enable theora)
}

src_install() {
	if [[ ${CELESTIA_GUI} == gnome ]]; then
		gnome2_src_install
	else
		emake DESTDIR="${D}" install
		local size
		for size in 16 22 32 48 ; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps
			newins "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
		done
	fi
	[[ ${CELESTIA_GUI} == glut ]] && domenu celestia.desktop
	dodoc AUTHORS README TRANSLATORS *.txt
}
