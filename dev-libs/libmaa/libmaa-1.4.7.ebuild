# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing toolchain-funcs

DESCRIPTION="Library with low-level data structures which are helpful for writing compilers"
HOMEPAGE="http://www.dict.org/"
SRC_URI="mirror://sourceforge/dict/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~riscv ~sparc ~x86"

BDEPEND="dev-util/mk-configure"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.7-makefile-respect-flags.patch
)

src_configure() {
	local jobs="$(makeopts_jobs)"
	unset MAKEOPTS

	export MAKEOPTS="-j${jobs}"
	export MAKE=bmake

	MAKEARGS=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		NM="$(tc-getNM)"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"
		RANLIB="$(tc-getRANLIB)"
		STRIP="$(tc-getSTRIP)"
		#SIZE="$(tc-getSIZE)"

		# Don't use LD, use the compiler driver instead
		LDCOMPILER=yes

		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"

		# Our toolchain already handles these
		MKPIE=no
		USE_SSP=no
		USE_RELRO=no
		USE_FORT=no

		# No -Werror
		WARNERR=no

		INSTALL="${INSTALL:-${BROOT}/usr/bin/install}"

		# Don't calcify compiler settings in installed files
		MKCOMPILERSETTINGS=yes

		PREFIX="${EPREFIX}/usr"
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		INFODIR="${EPREFIX}/usr/share/info"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"

		MKFILESDIR="${BROOT}/usr/share/mk-configure/mk"
		BUILTINSDIR="${BROOT}/usr/share/mk-configure/builtins"
		FEATURESDIR="${BROOT}/usr/share/mk-configure/feature"
	)

	mkcmake "${MAKEARGS[@]}" -j1 configure || die
}

src_compile() {
	mkcmake "${MAKEARGS[@]}" all || die
}

src_test() {
	mkcmake "${MAKEARGS[@]}" test || die
}

src_install() {
	mkcmake "${MAKEARGS[@]}" DESTDIR="${ED}" install

	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die

	dodoc doc/libmaa.600dpi.ps

	# don't want static or libtool archives, #401935
	find "${D}" \( -name '*.a' -o -name '*.la' \) -delete || die
}
