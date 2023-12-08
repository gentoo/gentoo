# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multiprocessing toolchain-funcs

DESCRIPTION="Lightweight replacement for GNU autotools"
HOMEPAGE="https://sourceforge.net/projects/mk-configure/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${P}.tar.gz"

LICENSE="BSD BSD-2 GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# TODO: investigate
RESTRICT="test"

RDEPEND="
	|| ( x11-misc/makedepend sys-devel/pmake )
	sys-devel/bmake
"
BDEPEND="${RDEPEND}"

src_configure() {
	local jobs="$(makeopts_jobs)"
	unset MAKEOPTS

	export MAKEOPTS="-j${jobs}"
	export MAKE=bmake
}

src_compile() {
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

	emake cleandir-presentation "${MAKEARGS[@]}"
	emake "${MAKEARGS[@]}"
}

src_test() {
	emake "${MAKEARGS[@]}" test
}

src_install() {
	emake "${MAKEARGS[@]}" DESTDIR="${ED}" install

	rm "${ED}"/usr/share/doc/${PF}/LICENSE || die
}
