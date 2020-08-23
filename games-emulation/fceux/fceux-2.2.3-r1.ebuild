# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 desktop scons-utils toolchain-funcs

DESCRIPTION="A portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="http://fceux.com/"
SRC_URI="mirror://sourceforge/fceultra/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk logo +lua +opengl"

RDEPEND="
	lua? ( dev-lang/lua:0 )
	media-libs/libsdl[opengl?,video]
	logo? ( media-libs/gd[png] )
	opengl? ( virtual/opengl )
	gtk? ( x11-libs/gtk+:3 )
	sys-libs/zlib[minizip]
"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}"/${PN}-2.2.2-warnings.patch)

src_prepare() {
	default

	tc-export CC CXX
}

src_compile() {
	escons \
		GTK=0 \
		CREATE_AVI=1 \
		SYSTEM_LUA=1 \
		SYSTEM_MINIZIP=1 \
		GTK3=$(usex gtk 1 0) \
		LOGO=$(usex logo 1 0) \
		OPENGL=$(usex opengl 1 0) \
		LUA=$(usex lua 1 0)
}

src_install() {
	dobin bin/fceux

	doman documentation/fceux.6
	docompress -x /usr/share/doc/${PF}/documentation /usr/share/doc/${PF}/fceux.chm
	dodoc -r Authors changelog.txt TODO-SDL bin/fceux.chm documentation
	rm -f "${D}/usr/share/doc/${PF}/documentation/fceux.6"
	make_desktop_entry fceux FCEUX
	doicon fceux.png
}
