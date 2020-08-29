# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit check-reqs git-r3 python-any-r1 scons-utils subversion
EGIT_REPO_URI="https://github.com/VDrift/vdrift.git"
ESVN_REPO_URI="https://svn.code.sf.net/p/vdrift/code/vdrift-data"
CHECKREQS_DISK_BUILD="2G"

DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/libvorbis
	net-misc/curl
	sci-physics/bullet[-double-precision]
"
DEPEND="${RDEPEND}"

src_unpack() {
	git-r3_src_unpack
	subversion_fetch "" "data" ||
		die "${ESVN}: unknown problem occurred in subversion_fetch."
}

src_configure() {
	scons_opts=(
		release=1
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		CXXFLAGS="-Wall ${CXXFLAGS}"
		LINKFLAGS="${LDFLAGS}"
	)
}

src_compile() {
	escons "${scons_opts[@]}"
}

src_install() {
	escons "${scons_opts[@]}" prefix="/usr" destdir="${D}" install
}
