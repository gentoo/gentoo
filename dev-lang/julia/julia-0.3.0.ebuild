# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RESTRICT="test"

inherit elisp-common eutils multilib pax-utils toolchain-funcs

PDSFMT=dSFMT-src-2.2

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI="
	https://github.com/JuliaLang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/${PDSFMT}.tar.gz
	https://dev.gentoo.org/~patrick/libuv-${P}.tar.bz2
	https://dev.gentoo.org/~patrick/rmath-0_p20140821.tar.bz2
	http://www.public-software-group.org/pub/projects/utf8proc/v1.1.6/utf8proc-v1.1.6.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

RDEPEND="
	dev-lang/R:0=
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	dev-libs/libpcre:3=
	dev-libs/mpfr:0=
	dev-libs/openspecfun
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/cholmod:0=
	sci-libs/fftw:3.0=
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	=sys-devel/llvm-3.4*
	>=sys-libs/libunwind-1.1:7=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	virtual/blas
	virtual/lapack
	emacs? ( app-emacs/ess )"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

src_prepare() {
	ln -s "${DISTDIR}"/${PDSFMT}.tar.gz deps/dsfmt-2.2.tar.gz || die
	ln -s "${DISTDIR}"/utf8proc-v1.1.6.tar.gz deps/utf8proc-v1.1.6.tar.gz || die
	cp  -ar "${WORKDIR}"/Rmath deps/ || die
	rmdir deps/libuv && ln -s "${WORKDIR}"/libuv deps/libuv
	# no fetching in ebuild
	# /usr/include/suitesparse is for debian only
	# respect prefix, flags
	sed -i \
		-e 's|$(JLDOWNLOAD)|${EPREFIX}/bin/true|' \
		-e 's|git submodule|${EPREFIX}/bin/true|g' \
		-e 's|^\(SUITESPARSE_INC\s*=\).*||g' \
		-e "s|-O3|${CFLAGS}|g" \
		-e 's|/usr/bin/||g' \
		-e "s|/usr/include|${EPREFIX%/}/usr/include|g" \
		deps/Makefile || die

	sed -i \
		-e "s|\(JULIA_EXECUTABLE = \)\(\$(JULIAHOME)/julia\)|\1 LD_LIBRARY_PATH=\$(BUILD)/$(get_libdir) \2|" \
		-e "s|-O3|${CFLAGS}|g" \
		-e "s|LIBDIR = lib|LIBDIR = $(get_libdir)|" \
		-e "s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" \
		-e "s|/usr/include|${EPREFIX}/usr/include|" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|" \
		-e "s|^JULIA_COMMIT = .*|JULIA_COMMIT = v${PV}|" \
		Make.inc || die

	sed -i \
		-e "s|,lib)|,$(get_libdir))|g" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		Makefile || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		src/Makefile || die

}

src_configure() {
	# libuv is an incompatible fork from upstream, so don't use system one
	cat <<-EOF > Make.user
		USE_LLVM_SHLIB=1
		USE_SYSTEM_ARPACK=1
		USE_SYSTEM_BLAS=1
		USE_SYSTEM_FFTW=1
		USE_SYSTEM_GMP=1
		USE_SYSTEM_GRISU=1
		USE_SYSTEM_LAPACK=1
		USE_SYSTEM_LIBM=1
		USE_SYSTEM_LIBUNWIND=1
		USE_SYSTEM_LIBUV=0
		USE_SYSTEM_LLVM=1
		USE_SYSTEM_MPFR=1
		USE_SYSTEM_OPENLIBM=1
		USE_SYSTEM_OPENSPECFUN=1
		USE_SYSTEM_PCRE=1
		USE_SYSTEM_READLINE=1
		USE_SYSTEM_RMATH=1
		USE_SYSTEM_SUITESPARSE=1
		USE_SYSTEM_ZLIB=1
		VERBOSE=1
	EOF
}

src_compile() {
	# Not parallel-safe, #514882
	emake -j1 cleanall
	if [[ $(get_libdir) != lib ]]; then
		mkdir -p usr/$(get_libdir) || die
		ln -s $(get_libdir) usr/lib || die
	fi
	emake -j1 julia-release prefix="/usr" DESTDIR="${D}"
	pax-mark m $(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')
	emake
	use emacs && elisp-compile contrib/julia-mode.el
}

src_test() {
	emake test
}

src_install() {
	emake install prefix="/usr" DESTDIR="${D}"
	cat > 99julia <<-EOF
		LDPATH=${EROOT%/}/usr/$(get_libdir)/julia
	EOF
	doenvd 99julia

	if use emacs; then
		elisp-install "${PN}" contrib/julia-mode.el
		elisp-site-file-install "${FILESDIR}"/63julia-gentoo.el
	fi
	dodoc README.md
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
