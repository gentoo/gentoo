# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Tools for DNA/RNA sequence database handling and phylogenetic analysis"
HOMEPAGE="http://www.arb-home.de/"
SRC_URI="http://download.arb-home.de/release/${P}/${P}-source.tgz -> ${P}.tgz"

SLOT="0"
LICENSE="arb"
IUSE="debug +opengl test"
KEYWORDS="~amd64 ~x86"

CDEPEND="app-text/sablotron
	media-libs/libpng:=
	media-libs/tiff:=
	www-client/lynx
	x11-libs/libXaw
	x11-libs/libXpm
	x11-libs/motif:0
	opengl? (
		media-libs/glew:=
		media-libs/freeglut
		|| (
			media-libs/mesa[motif]
			( media-libs/mesa x11-libs/libGLw ) ) )"
DEPEND="${CDEPEND}
	sys-process/time
	x11-misc/makedepend"
RDEPEND="${CDEPEND}
	sci-visualization/gnuplot"

# Almost half of tests are broken with debug
RESTRICT="debug? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.6-glapi.patch
	"${FILESDIR}"/${PN}-6.0.6-tc-flags.patch
	"${FILESDIR}"/${PN}-6.0.6-arb_install.patch
)

src_unpack() {
	default
	mv arbsrc* ${P} || die
}

src_prepare() {
	default

	cp config.makefile.template config.makefile
	mkdir "${S}"/patches.arb || die  # Test script expects ${ARBHOME}/patches.arb to exist

	if use amd64; then
		sed -i -e 's@ARB_64 := 0@ARB_64 := 1@' config.makefile || die
	fi
	if use opengl; then
		sed -i -e 's@OPENGL := 0@OPENGL := 1@' config.makefile || die
	fi
	if use test; then
		sed -i -e 's@UNIT_TESTS := 0@UNIT_TESTS := 1@' config.makefile || die
	fi
	if use debug; then
		sed -i -e 's@DEBUG := 0@DEBUG := 1@' \
		-e 's@DEBUG_GRAPHICS := 0@DEBUG_GRAPHICS := 1@' config.makefile || die
	fi
}

src_compile() {
	emake ARBHOME="${S}" PATH="${S}/bin:${PATH}" LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" build
}

src_test() {
	emake ARBHOME="${S}" PATH="${S}/bin:${PATH}" LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" run_tests
}

src_install() {
	emake ARBHOME="${S}" PATH="${S}/bin:${PATH}" LD_LIBRARY_PATH="${S}/lib:${LD_LIBRARY_PATH}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" prepare_libdir
	"${S}"/util/arb_compress  || die
	if use amd64; then
		mv arb.tgz arb.64.gentoo.tgz || die
	fi
	if use x86; then
		mv arb.tgz arb.32.gentoo.tgz || die
	fi
	ln -s arb.*.tgz arb.tgz || die
	ARBHOME="${D}/opt/arb" "${S}/arb_install.sh" || die

	cat <<- EOF > "${S}/99${PN}" || die
		ARBHOME=/opt/arb
		PATH=/opt/arb/bin
		LD_LIBRARY_PATH=/opt/arb/lib
	EOF
	doenvd "${S}/99${PN}"
}
