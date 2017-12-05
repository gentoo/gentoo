# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

DESCRIPTION="open source high performance realtime 3D engine written in C++"
HOMEPAGE="http://irrlicht.sourceforge.net/"
SRC_URI="mirror://sourceforge/irrlicht/${P}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="debug doc static-libs"

RDEPEND="virtual/jpeg:0
	media-libs/libpng:0=
	app-arch/bzip2
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-proto/xproto
	x11-proto/xf86vidmodeproto"

S=${WORKDIR}/${P}/source/${PN^}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-config.patch
	"${FILESDIR}"/${P}-demoMake.patch
	"${FILESDIR}"/${P}-mesa-10.x.patch
	"${FILESDIR}"/${P}-jpeg-9a.patch )

DOCS=( changes.txt readme.txt )

src_prepare() {
	cd "${WORKDIR}"/${P} || die
	edos2unix include/IrrCompileConfig.h
	sed -i \
		-e 's:\.\./\.\./media:../media:g' \
		$(grep -rl '\.\./\.\./media' examples) \
		|| die 'sed failed'
	default
}

src_compile() {
	tc-export CXX CC AR
	emake NDEBUG=$(usex debug "" "1") sharedlib $(usex static-libs "staticlib" "")
}

src_install() {
	cd "${WORKDIR}"/${P} || die

	use static-libs && dolib.a lib/Linux/libIrrlicht.a
	dolib.so lib/Linux/libIrrlicht.so*

	# create library symlinks
	dosym libIrrlicht.so.${PV} /usr/$(get_libdir)/libIrrlicht.so.1.8
	dosym libIrrlicht.so.${PV} /usr/$(get_libdir)/libIrrlicht.so

	insinto /usr/include/${PN}
	doins include/*

	einstalldocs

	# don't do these with einstalldocs because they shouldn't be compressed
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins -r examples media
	fi
}
