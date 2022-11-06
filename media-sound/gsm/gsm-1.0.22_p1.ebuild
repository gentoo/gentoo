# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Lossy speech compression library and tool"
HOMEPAGE="https://packages.qa.debian.org/libg/libgsm.html"
SRC_URI="
	https://www.quut.com/gsm/${PN}-$(ver_cut 1-3).tar.gz
	mirror://debian/pool/main/libg/lib${PN}/lib${PN}_${PV/_p/-}.debian.tar.xz
"
S="${WORKDIR}/${PN}-$(ver_cut 1-2)-pl$(ver_cut 3)"

LICENSE="gsm"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.12-memcpy.patch
	"${FILESDIR}"/${PN}-1.0.12-64bit.patch
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${PN}-1.0.22-makefile.patch
)

DOCS=( ChangeLog MACHINES MANIFEST README )

src_prepare() {
	# Use Fedora's instead as it handles install perms (bug #554358)
	rm "${WORKDIR}"/debian/patches/01_makefile.patch || die

	default

	sed -e 's/\$(GSM_INSTALL_LIB)\/libgsm.a	//g' -i Makefile || die

	multilib_copy_sources
}

src_configure() {
	# From upstream Makefile. Define this if your host multiplies
	# floats faster than integers, e.g. on a SPARCstation.
	use sparc && append-flags -DUSE_FLOAT_MUL -DFAST
}

multilib_src_compile() {
	emake -j1 CCFLAGS="${CFLAGS} -c -DNeedFunctionPrototypes=1 -fPIC" \
		LD="$(tc-getCC)" AR="$(tc-getAR)" CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)"
}

multilib_src_install() {
	dodir /usr/bin /usr/$(get_libdir) /usr/include/gsm /usr/share/man/man{1,3}

	emake -j1 INSTALL_ROOT="${ED}"/usr \
		LD="$(tc-getCC)" AR="$(tc-getAR)" CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)" \
		GSM_INSTALL_LIB="${ED}"/usr/$(get_libdir) \
		GSM_INSTALL_INC="${ED}"/usr/include/gsm \
		GSM_INSTALL_MAN="${ED}"/usr/share/man/man3 \
		TOAST_INSTALL_MAN="${ED}"/usr/share/man/man1 \
		install

	dosym ../gsm/gsm.h /usr/include/libgsm/gsm.h
}
