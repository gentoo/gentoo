# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic xdg-utils

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestia.space"
if [[ "${PV}" = 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
else
	# Old URI! Please update once we have a release > v1.6.1
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="cairo gtk nls pch theora threads"

RDEPEND="
	virtual/opengl
	virtual/jpeg:0
	media-libs/libpng:0=
	>=dev-lang/lua-5.1:*
	gtk? (
		x11-libs/gtk+:2
		>=x11-libs/gtkglext-1.0
	)
	!gtk? ( media-libs/freeglut )
	cairo? ( x11-libs/cairo )
	theora? ( media-libs/libtheora )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	# make better desktop files
	"${FILESDIR}"/${PN}-1.5.0-desktop.patch
	# add a ~/.celestia for extra directories
	"${FILESDIR}"/${PN}-1.6.99-cfg.patch
)

pkg_setup() {
	# Check for one for the following use flags to be set.
	if use gtk; then
		einfo "USE=\"gtk\" detected."
		CELESTIA_GUI="gtk"
	else
		ewarn "If you want to use the full gui, set USE=\"gtk\""
		ewarn "Defaulting to glut support (no GUI)."
		CELESTIA_GUI="glut"
	fi
}

src_prepare() {
	default

	# remove flags to let the user decide
	local cf
	for cf in -O2 -ffast-math \
		-fexpensive-optimizations \
		-fomit-frame-pointer; do
		sed -i \
			-e "s/${cf}//g" \
			configure.ac admin/* || die "sed failed"
	done
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
	emake DESTDIR="${D}" install
	local size
	for size in 16 22 32 48 ; do
		newicon "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
	done

	[[ ${CELESTIA_GUI} == glut ]] && domenu celestia.desktop
	dodoc AUTHORS README TRANSLATORS *.txt
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
