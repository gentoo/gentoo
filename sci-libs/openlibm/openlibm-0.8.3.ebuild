# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="https://github.com/JuliaLang/openlibm"
SRC_URI="https://github.com/JuliaMath/openlibm/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="static-libs"
LICENSE="public-domain MIT ISC BSD-2 LGPL-2.1+"
# See https://abi-laboratory.pro/index.php?view=timeline&l=openlibm
SLOT="0/4"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-stack-protection.patch
	"${FILESDIR}"/${P}-fix-loong-riscv-fenv.patch
)

src_prepare() {
	default
	sed -e "/^OLM_LIBS :=/s/^/#/" -i Makefile || die
	if ! use static-libs ; then
		sed -e "/install: /s/install-static//" -i Makefile || die
	fi
}

src_compile() {
	# Build system uses different ARCH for the following arches
	case "${ARCH}" in
		loong) export ARCH=loongarch64 ;;
		riscv) export ARCH=riscv64 ;;
		x86) export ARCH=i387 ;;
	esac

	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		FC="$(tc-getFC)" \
		AR="$(tc-getAR)" \
		LD="$(tc-getLD)"
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" install
	dodoc README.md
}
