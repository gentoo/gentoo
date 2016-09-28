# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

RESTRICT="test"

inherit elisp-common eutils multilib pax-utils toolchain-funcs

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="http://julialang.org/"
SRC_URI="
	https://github.com/JuliaLang/${PN}/releases/download/v${PV}/${P}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/${P}-bundled.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="emacs"

RDEPEND="
	dev-lang/R:0=
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	dev-libs/libgit2:0=
	dev-libs/mpfr:0=
	dev-libs/openspecfun
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/cholmod:0=
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	>=sys-devel/llvm-3.5:0=
	>=sys-libs/libunwind-1.1:7=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	>=virtual/blas-3.6
	virtual/lapack
	emacs? ( app-emacs/ess )"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.0-fix_build_system.patch
)

src_prepare() {
	mkdir deps/srccache || die
	mv "${WORKDIR}"/bundled/* deps/srccache || die
	rmdir "${WORKDIR}"/bundled || die

	epatch "${PATCHES[@]}"

	eapply_user

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths
	# - fix BLAS and LAPACK link interface

	sed -i \
		-e 's|$(JLDOWNLOAD)|${EPREFIX}/bin/true|' \
		-e 's|git submodule|${EPREFIX}/bin/true|g' \
		-e "s|GENTOOCFLAGS|${CFLAGS}|g" \
		-e "s|/usr/include|${EPREFIX%/}/usr/include|g" \
		deps/Makefile || die

	local libblas="$($(tc-getPKG_CONFIG) --libs-only-l blas)"
	libblas="${libblas%% *}"
	libblas="lib${libblas#-l}"
	local liblapack="$($(tc-getPKG_CONFIG) --libs-only-l lapack)"
	liblapack="${liblapack%% *}"
	liblapack="lib${liblapack#-l}"

	sed -i \
		-e "s|\(JULIA_EXECUTABLE = \)\(\$(JULIAHOME)/julia\)|\1 LD_LIBRARY_PATH=\$(BUILD)/$(get_libdir) \2|" \
		-e "s|GENTOOCFLAGS|${CFLAGS}|g" \
		-e "s|LIBDIR = lib|LIBDIR = $(get_libdir)|" \
		-e "s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" \
		-e "s|/usr/include|${EPREFIX}/usr/include|" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|" \
		-e "s|^JULIA_COMMIT = .*|JULIA_COMMIT = v${PV}|" \
		-e "s|-lblas|$($(tc-getPKG_CONFIG) --libs blas)|" \
		-e "s|= libblas|= ${libblas}|" \
		-e "s|-llapack|$($(tc-getPKG_CONFIG) --libs lapack)|" \
		-e "s|= liblapack|= ${liblapack}|" \
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
	# julia does not play well with the system versions of
	# dsfmt, libuv, pcre2 and utf8proc
	cat <<-EOF > Make.user
		USE_SYSTEM_DSFMT=0
		USE_SYSTEM_LIBUV=0
		USE_SYSTEM_PCRE=0
		USE_SYSTEM_RMATH=0
		USE_SYSTEM_UTF8PROC=0
		USE_LLVM_SHLIB=1
		USE_SYSTEM_ARPACK=1
		USE_SYSTEM_BLAS=1
		USE_SYSTEM_FFTW=1
		USE_SYSTEM_GMP=1
		USE_SYSTEM_GRISU=1
		USE_SYSTEM_LAPACK=1
		USE_SYSTEM_LIBGIT2=1
		USE_SYSTEM_LIBM=1
		USE_SYSTEM_LIBUNWIND=1
		USE_SYSTEM_LLVM=1
		USE_SYSTEM_MPFR=1
		USE_SYSTEM_OPENLIBM=1
		USE_SYSTEM_OPENSPECFUN=1
		USE_SYSTEM_PATCHELF=1
		USE_SYSTEM_READLINE=1
		USE_SYSTEM_SUITESPARSE=1
		USE_SYSTEM_ZLIB=1
		VERBOSE=1
		libdir="${EROOT}/usr/$(get_libdir)"
	EOF

}

src_compile() {

	# Julia accesses /proc/self/mem on Linux
	addpredict /proc/self/mem

	emake cleanall
	emake julia-release \
		prefix="/usr" DESTDIR="${D}" CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	pax-mark m $(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')
	emake
	use emacs && elisp-compile contrib/julia-mode.el
}

src_test() {
	emake test
}

src_install() {
	emake install \
		prefix="/usr" DESTDIR="${D}" CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	cat > 99julia <<-EOF
		LDPATH=${EROOT%/}/usr/$(get_libdir)/julia
	EOF
	doenvd 99julia

	if use emacs; then
		elisp-install "${PN}" contrib/julia-mode.el
		elisp-site-file-install "${FILESDIR}"/63julia-gentoo.el
	fi
	dodoc README.md

	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
	rmdir "${ED}"/usr/etc || die
	rmdir "${ED}"/usr/libexec || die
	mv "${ED}"/usr/share/doc/julia/{examples,html} \
		"${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/julia || die
	if [[ $(get_libdir) != lib ]]; then
		mkdir -p "${ED}"/usr/$(get_libdir) || die
		mv "${ED}"/usr/lib/julia "${ED}"/usr/$(get_libdir)/julia || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
