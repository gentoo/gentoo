# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Lossy speech compression library and tool"
HOMEPAGE="https://www.quut.com/gsm/  https://tracker.debian.org/pkg/libgsm"
SRC_URI="https://www.quut.com/gsm/${P}.tar.gz"
S="${WORKDIR}/${PN}-$(ver_cut 1-2)-pl$(ver_cut 3)"

LICENSE="gsm"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.23-makefile.patch
)

DOCS=( ChangeLog MACHINES MANIFEST README )

src_prepare() {
	default

	multilib_copy_sources
}

src_configure() {
	# From upstream Makefile. Define this if your host multiplies
	# floats faster than integers, e.g. on a SPARCstation.
	use sparc && append-flags -DUSE_FLOAT_MUL -DFAST
}

multilib_src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
	)
	emake -j1 CCFLAGS="${CFLAGS} -c -DNeedFunctionPrototypes=1 -fPIC" "${myemakeargs[@]}"
}

multilib_src_install() {
	dodir /usr/bin /usr/$(get_libdir) /usr/include/gsm /usr/share/man/man{1,3}

	local myemakeargs=(
		CC="$(tc-getCC)"
		LD="$(tc-getCC)"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		INSTALL_ROOT="${ED}"/usr
		GSM_INSTALL_LIB="${ED}"/usr/$(get_libdir)
		GSM_INSTALL_INC="${ED}"/usr/include/gsm
		GSM_INSTALL_MAN="${ED}"/usr/share/man/man3
		TOAST_INSTALL_MAN="${ED}"/usr/share/man/man1
	)
	emake -j1 "${myemakeargs[@]}" install

	dosym ../gsm/gsm.h /usr/include/libgsm/gsm.h
}
