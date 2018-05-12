# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic gnome2 xdg-utils

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestia.space"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
	# Necessary because of gnome2 eclass
	SRC_URI=""
else
	# Old URI! Please update once we have a release > v1.6.1
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="cairo gnome gtk nls pch theora threads"

RDEPEND="
	virtual/opengl
	virtual/jpeg:0
	media-libs/libpng:0=
	>=dev-lang/lua-5.1:*
	gtk? (
		x11-libs/gtk+:2
		>=x11-libs/gtkglext-1.0
	)
	gnome? (
		>=gnome-base/libgnomeui-2.0
	)
	!gtk? ( !gnome? ( media-libs/freeglut ) )
	cairo? ( x11-libs/cairo )
	theora? ( media-libs/libtheora )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="gnome? ( gtk )"

PATCHES=(
	# make better desktop files
	"${FILESDIR}"/${PN}-1.5.0-desktop.patch
	# add a ~/.celestia for extra directories
	"${FILESDIR}"/${PN}-1.6.99-cfg.patch
	# missing zlib.h include with libpng15
	"${FILESDIR}"/${PN}-1.6.1-libpng15.patch
	"${FILESDIR}"/${PN}-1.6.99-linking.patch

	# gcc-47, #414015
	"${FILESDIR}"/${PN}-1.6.99-gcc47.patch

	# libpng16 #464764
	"${FILESDIR}"/${PN}-1.6.1-libpng16.patch

	# Patches from upstream PRs

	# https://github.com/CelestiaProject/Celestia/pull/35
	#"${FILESDIR}/${PN}-1.6.99-automake.patch"
	"${FILESDIR}/${PN}-1.6.99-models_makefile.patch"
	"${FILESDIR}/${PN}-1.6.99-default_source.patch"
	"${FILESDIR}/${PN}-1.6.99-symlink.patch"

	# https://github.com/CelestiaProject/Celestia/pull/37
	"${FILESDIR}/${PN}-1.6.99-compiler_warnings.patch"
)

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
	default

	if [[ -f configure.in ]] ; then
		mv configure.{in,ac} || die
	else
		elog "configure.in file is gone. Clean up the ebuild!"
	fi

	# remove flags to let the user decide
	local
	for cf in -O2 -ffast-math \
		-fexpensive-optimizations \
		-fomit-frame-pointer; do
		sed -i \
			-e "s/${cf}//g" \
			configure.ac admin/* || die "sed failed"
	done
	# remove an unused gconf macro killing autoconf when no gnome
	# (not needed without eautoreconf)
	if ! use gnome; then
		sed -i \
			-e '/AM_GCONF_SOURCE_2/d' \
			configure.ac || die "sed failed"
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
	local myeconfargs=(
		--disable-rpath
		--with-${CELESTIA_GUI}
		--with-lua
		$(use_enable cairo)
		$(use_enable threads threading)
		$(use_enable nls)
		$(use_enable pch)
		$(use_enable theora)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	if [[ ${CELESTIA_GUI} == gnome ]]; then
		gnome2_src_install
	else
		emake DESTDIR="${D}" MKDIR_P="mkdir -p" install
		local size
		for size in 16 22 32 48 ; do
			newicon "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
		done
	fi
	[[ ${CELESTIA_GUI} == glut ]] && domenu celestia.desktop
	dodoc AUTHORS README TRANSLATORS *.txt
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
