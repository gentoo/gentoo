# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit scons-utils toolchain-funcs flag-o-matic xdg-utils

DESCRIPTION="free Lemmings clone"
HOMEPAGE="https://pingus.seul.org"
SRC_URI="https://pingus.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl music"

RDEPEND="media-libs/libsdl[joystick,opengl?,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mod] )
	opengl? ( virtual/opengl )
	media-libs/libpng:0=
	dev-libs/boost:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-noopengl.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-echo-e.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${P}-boost_signals2.patch
)

src_prepare() {
	default
	strip-flags
}

src_compile() {
	escons \
		CXX="$(tc-getCXX)" \
		CCFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		with_opengl=$(usex opengl 1 0)
}

src_install() {
	emake install-exec install-data \
		DESTDIR="${D}" \
		PREFIX="/usr"
	doman doc/man/pingus.6
	doicon data/images/icons/pingus.svg
	make_desktop_entry ${PN} Pingus
	dodoc AUTHORS NEWS README TODO
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
