# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic vcs-clean

MY_P=${PN}-srcdata-$(ver_rs 1- '')1

DESCRIPTION="Remake of the famous Stunts game"
HOMEPAGE="http://www.ultimatestunts.nl/"
SRC_URI="mirror://sourceforge/ultimatestunts/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	media-libs/freealut
	media-libs/libsdl[joystick,opengl,video]
	media-libs/libvorbis
	>=media-libs/openal-1
	media-libs/sdl-image
	virtual/opengl
	virtual/glu
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-paths.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
)

src_prepare() {
	default

	esvn_clean
	append-cppflags $(sdl-config --cflags)
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859241
	# Upstream sourceforge is inactive since 2017. No bug filed
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	econf \
		--with-openal \
		$(use_enable nls)
}

src_compile() {
	emake -C trackedit libtrackedit.a
	emake
}

src_install() {
	default

	newicon data/cars/diablo/steer.png ${PN}.png
	make_desktop_entry ustunts "Ultimate Stunts"
}
