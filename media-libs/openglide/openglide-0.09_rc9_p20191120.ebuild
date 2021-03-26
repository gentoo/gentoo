# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="c300160d0a8292bc04e79dd59e6cc178aa648dec"

inherit autotools eutils multilib-minimal

DESCRIPTION="A Glide to OpenGL wrapper"
HOMEPAGE="http://openglide.sourceforge.net/"
SRC_URI="https://github.com/voyageur/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sdl static-libs"

RDEPEND="virtual/glu[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	sdl? (
		media-libs/libsdl[${MULTILIB_USEDEP}]
	)
	!sdl? (
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libXxf86vm[${MULTILIB_USEDEP}]
	)"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"
ECONF_SOURCE="${S}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/openglide/sdk2_unix.h
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	econf \
		--enable-shared \
		--disable-sdltest \
		$(use_enable sdl) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	insinto /etc
	doins "${FILESDIR}"/OpenGLid.ini

	exeinto /usr/share/${PN}
	newexe platform/dosbox/glide2x.ovl glide2x-dosbox.ovl
	newexe platform/dosemu/glide2x.ovl glide2x-dosemu.ovl

	# Drop the libtool file *if* it exists
	# bug #778266
	find "${ED}" -name '*.la' -delete || die

	einstalldocs
}
