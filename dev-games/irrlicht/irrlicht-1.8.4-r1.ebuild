# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils toolchain-funcs

DESCRIPTION="open source high performance realtime 3D engine written in C++"
HOMEPAGE="http://irrlicht.sourceforge.net/"
SRC_URI="mirror://sourceforge/irrlicht/${P}.zip
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc static-libs"

RDEPEND="app-arch/bzip2
	~dev-games/irrlicht-headers-${PV}
	media-libs/libpng:0=
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-arch/unzip"

S=${WORKDIR}/${P}/source/${PN^}

PATCHES=(
	"${WORKDIR}"/${P}-patchset/${P}-gentoo.patch
	"${WORKDIR}"/${P}-patchset/${P}-demoMake.patch
	"${WORKDIR}"/${P}-patchset/${P}-mesa-10.x.patch
	"${WORKDIR}"/${P}-patchset/${P}-jpeg-9a.patch
	"${FILESDIR}/${P}-remove-sys-sysctl.h.patch"
)

DOCS=( changes.txt readme.txt )

src_prepare() {
	cd "${WORKDIR}"/${P} || die

	# Use system-provided Irrlicht headers
	rm -r include || die
	ln -s "${ESYSROOT}/usr/include/irrlicht" include || die

	# Fix relative path to media directory
	sed -i \
		-e 's:\.\./\.\./media:../media:g' \
		$(grep -rl '\.\./\.\./media' examples) \
		|| die 'sed failed'

	# Fix line endings so ${P}-remove-sys-sysctl.h.patch applies
	sed -i \
		-e 's/\r$//' \
		source/Irrlicht/COSOperator.cpp \
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

	einstalldocs

	# don't do these with einstalldocs because they shouldn't be compressed
	if use doc ; then
		dodoc -r examples media
	fi
}
