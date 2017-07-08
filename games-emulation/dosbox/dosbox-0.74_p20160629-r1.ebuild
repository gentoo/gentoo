# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils flag-o-matic

PATCH=3989
GLIDE_PATCH=3722fc563b737d2d7933df6a771651c2154e6f7b

DESCRIPTION="DOS emulator"
HOMEPAGE="http://dosbox.sourceforge.net/"
SRC_URI="mirror://gentoo/dosbox-code-0-${PATCH}-dosbox-trunk.zip
	glide? ( https://raw.githubusercontent.com/voyageur/openglide/${GLIDE_PATCH}/platform/dosbox/dosbox_glide.diff -> dosbox_glide-${GLIDE_PATCH}.diff )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="alsa debug glide hardened opengl"

RDEPEND="alsa? ( media-libs/alsa-lib )
	glide? ( media-libs/openglide )
	opengl? ( virtual/glu virtual/opengl )
	debug? ( sys-libs/ncurses:0 )
	media-libs/libpng:0
	media-libs/libsdl[joystick,video,X]
	media-libs/sdl-net
	media-libs/sdl-sound"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${PN}-code-0-${PATCH}-dosbox-trunk

PATCHES=(
"${FILESDIR}"/dosbox-0.74-gcc46.patch
)

src_prepare() {
	use glide && eapply "${DISTDIR}"/dosbox_glide-${GLIDE_PATCH}.diff
	default
	eautoreconf
}

src_configure() {
	use glide && append-cppflags -I"${EPREFIX}"/usr/include/openglide

	econf \
		$(use_enable alsa alsa-midi) \
		$(use_enable !hardened dynamic-core) \
		$(use_enable !hardened dynamic-x86) \
		$(use_enable debug) \
		$(use_enable opengl)
}

src_install() {
	default
	make_desktop_entry dosbox DOSBox /usr/share/pixmaps/dosbox.ico
	doicon src/dosbox.ico
}

pkg_postinst() {
	if use glide; then
		elog "You have enabled unofficial Glide emulation. To use this, symlink"
		elog "or copy ${EPREFIX}/usr/share/openglide/glide2x-dosbox.ovl to your game's"
		elog "directory and add the following to your DOSBox configuration."
		elog ""
		elog "[glide]"
		elog "glide=true"
	fi
}
