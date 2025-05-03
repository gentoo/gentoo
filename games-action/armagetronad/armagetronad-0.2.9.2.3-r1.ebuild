# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop

DESCRIPTION="Fast-paced 3D lightcycle game based on Tron"
HOMEPAGE="https://www.armagetronad.org/"
SRC_URI="https://launchpad.net/armagetronad/$(ver_cut 1-3)/${PV}/+download/armagetronad-${PV}.tbz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated sound"

RDEPEND="
	dev-libs/libxml2:=
	!dedicated? (
		media-libs/libpng:0=
		media-libs/libsdl[X,opengl,video,sound?]
		media-libs/sdl-image[jpeg,png]
		virtual/glu
		virtual/opengl
		sound? ( media-libs/sdl-mixer )
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.9.1.0-AR.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local econfargs=(
		$(use_enable dedicated)
		$(use_enable sound music)
		# following options only mess with paths and users
		--disable-games
		--disable-sysinstall
		--disable-uninstall
		--disable-useradd
	)
	econf ${econfargs[@]}
}

src_install() {
	# long history of being broken without -j1 (bug #330705,698020)
	# do not remove (again) without a proper fix or extensive tests
	emake -j1 DESTDIR="${D}" install
	einstalldocs

	# handle misplaced .desktop / icons
	if ! use dedicated; then
		rm -r "${ED}"/usr/share/${PN}/desktop || die
		doicon desktop/icons/48x48/armagetronad.png
		make_desktop_entry ${PN}
	fi
}
