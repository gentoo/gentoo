# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a

MY_P=Togl${PV}

DESCRIPTION="A Tk widget for OpenGL rendering"
HOMEPAGE="http://togl.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="debug +threads"

RDEPEND="
	dev-lang/tk:*
	media-libs/libglvnd[X]
	x11-libs/libX11
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

# tests directory is missing
RESTRICT="test"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-clang6.patch )

QA_CONFIG_IMPL_DECL_SKIP=(
	stat64 # used to test for Large File Support
)

src_prepare() {
	default
	sed \
		-e 's:-fomit-frame-pointer::g' \
		-e 's:-O2::g' \
		-e 's:-pipe::g' \
		-i configure || die
}

src_configure() {
	lto-guarantee-fat
	econf \
		$(use_enable debug symbols) \
		$(use_enable threads)
}

src_install() {
	HTML_DOCS=( doc/* )
	default
	strip-lto-bytecode
}
