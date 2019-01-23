# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop flag-o-matic

GLIDE_PATCH=841e1071597b64ead14dd08c25a03206b2d1d1b6
SRC_URI="glide? ( https://raw.githubusercontent.com/voyageur/openglide/${GLIDE_PATCH}/platform/dosbox/dosbox_glide.diff -> dosbox_glide-${GLIDE_PATCH}.diff )"

if [[ ${PV} = 9999 ]]; then
	ESVN_REPO_URI="https://svn.code.sf.net/p/dosbox/code-0/dosbox/trunk"
	inherit subversion
else
	SRC_URI+=" mirror://sourceforge/dosbox/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
fi

DESCRIPTION="DOS emulator"
HOMEPAGE="http://dosbox.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa debug glide hardened opengl X"

DEPEND="alsa? ( media-libs/alsa-lib )
	glide? ( media-libs/openglide )
	opengl? ( virtual/glu virtual/opengl )
	debug? ( sys-libs/ncurses:0 )
	X? ( x11-libs/libX11 )
	media-libs/libpng:0=
	media-libs/libsdl[joystick,opengl?,video,X]
	media-libs/sdl-net
	media-libs/sdl-sound
	sys-libs/zlib"
RDEPEND=${DEPEND}

if [[ ${PV} = 9999 ]]; then
	S=${WORKDIR}/${PN}
fi

PATCHES=(
	"${FILESDIR}"/${PN}-0.74-gcc46.patch
)

src_prepare() {
	use glide && eapply "${DISTDIR}"/dosbox_glide-${GLIDE_PATCH}.diff
	default
	eautoreconf
}

src_configure() {
	use glide && append-cppflags -I"${EPREFIX}"/usr/include/openglide

	ac_cv_lib_X11_main=$(usex X yes no) \
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
