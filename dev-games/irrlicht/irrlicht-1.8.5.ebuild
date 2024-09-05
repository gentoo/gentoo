# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Open source high performance realtime 3D engine written in C++"
HOMEPAGE="https://irrlicht.sourceforge.io/"
SRC_URI="
	https://downloads.sourceforge.net/irrlicht/${P}.zip
	https://dev.gentoo.org/~mgorny/dist/${PN}-1.8.4-patchset.tar.bz2"
S="${WORKDIR}/${P}/source/${PN^}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="debug doc"

RDEPEND="
	app-arch/bzip2
	~dev-games/irrlicht-headers-${PV}
	media-libs/libpng:=
	sys-libs/zlib:=
	media-libs/libjpeg-turbo:=
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${WORKDIR}"/${PN}-1.8.4-patchset/${PN}-1.8.4-gentoo.patch
	"${WORKDIR}"/${PN}-1.8.4-patchset/${PN}-1.8.4-demoMake.patch
	"${WORKDIR}"/${PN}-1.8.4-patchset/${PN}-1.8.4-mesa-10.x.patch
	"${WORKDIR}"/${PN}-1.8.4-patchset/${PN}-1.8.4-jpeg-9a.patch
	"${FILESDIR}"/${PN}-1.8.4-drop-register.patch
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
	emake NDEBUG=$(usev !debug 1) sharedlib
}

src_install() {
	cd "${WORKDIR}"/${P} || die

	dolib.so lib/Linux/libIrrlicht.so*

	# create library symlinks
	dosym libIrrlicht.so.${PV} /usr/$(get_libdir)/libIrrlicht.so.1.8
	dosym libIrrlicht.so.${PV} /usr/$(get_libdir)/libIrrlicht.so

	einstalldocs

	# don't do these with einstalldocs because they shouldn't be compressed
	use doc && dodoc -r examples media
}
