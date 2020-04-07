# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RESTRICT="splitdebug"

inherit llvm pax-utils toolchain-funcs

MY_PV="${PV//_rc/-rc}"
MY_CACERT_V="2020-01-01"
MY_DSFMT_V="2.2.3"
MY_LIBGIT2_V="b3e1a56ebb2b9291e82dc027ba9cbcfc3ead54d3"
MY_LIBUV_V="35b1504507a7a4168caae3d78db54d1121b121e1"
MY_LIBWHICH_V="81e9723c0273d78493dc8c8ed570f68d9ce7e89e"
MY_PKG_V="49908bffe83790bc7cf3c5d46faf3667f8902ad4"
MY_UTF8PROC_V="5c632c57426f2e4246e3b64dd2fd088d3920f9e5"

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"
SRC_URI="
	https://github.com/JuliaLang/${PN}/releases/download/v${MY_PV}/${PN}-${MY_PV}.tar.gz
	https://api.github.com/repos/JuliaLang/libuv/tarball/${MY_LIBUV_V} -> ${PN}-libuv-${MY_LIBUV_V}.tar.gz
	https://api.github.com/repos/JuliaLang/utf8proc/tarball/${MY_UTF8PROC_V} -> ${PN}-utf8proc-${MY_UTF8PROC_V}.tar.gz
	https://api.github.com/repos/libgit2/libgit2/tarball/${MY_LIBGIT2_V} -> ${PN}-libgit2-${MY_LIBGIT2_V}.tar.gz
	https://api.github.com/repos/vtjnash/libwhich/tarball/${MY_LIBWHICH_V} -> ${PN}-libwhich-${MY_LIBWHICH_V}.tar.gz
	https://curl.haxx.se/ca/cacert-${MY_CACERT_V}.pem -> ${PN}-cacert-${MY_CACERT_V}.pem
	http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/dSFMT-src-${MY_DSFMT_V}.tar.gz -> ${PN}-dsfmt-${MY_DSFMT_V}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/Pkg-${MY_PKG_V}.tar.gz -> ${PN}-Pkg-${MY_PKG_V}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-devel/llvm:9=[llvm_targets_NVPTX(-)]
"
LLVM_MAX_SLOT=9

RDEPEND+="
	dev-libs/double-conversion:0=
	dev-libs/gmp:0=
	>=dev-libs/libpcre2-10.23:0=[jit,unicode]
	dev-libs/mpfr:0=
	dev-libs/openspecfun
	>=net-libs/mbedtls-2.2
	sci-libs/amd:0=
	sci-libs/arpack:0=
	sci-libs/camd:0=
	sci-libs/ccolamd:0=
	sci-libs/cholmod:0=
	sci-libs/colamd:0=
	sci-libs/fftw:3.0=[threads]
	sci-libs/openlibm:0=
	sci-libs/spqr:0=
	sci-libs/umfpack:0=
	sci-mathematics/glpk:0=
	>=sys-libs/libunwind-1.1:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	>=virtual/blas-3.6
	virtual/lapack"

DEPEND="${RDEPEND}
	dev-util/patchelf
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-fix_build_system.patch
	"${FILESDIR}"/${PN}-1.1.0-fix_llvm_install.patch
	"${FILESDIR}"/${PN}-1.4.0-no_symlink_llvm.patch
)

S="${WORKDIR}/${PN}-${MY_PV}"

src_unpack() {
	tounpack=(${A})
	# the main source tree, followed by deps
	unpack "${A/%\ */}"

	mkdir -p "${S}/deps/srccache/"
	for i in "${tounpack[@]:1}"; do
		if [[ $i == *Pkg* ]] || [[ $i = *Statistics* ]]; then
			# Bundled Pkg and Statistics packages go into ./stdlib
			local tarball="${i#julia-}"
			cp "${DISTDIR}/${i}" "${S}/stdlib/srccache/${tarball}" || die
			# and we have to fix up the sha1sum
			local name="${tarball%-*}"
			local sha1="${tarball#*-}"
			sha1="${sha1%.tar*}"
			einfo "using patched stdlib package \"${name}\""
			sed -i -e "s/PKG_SHA1 = .*/PKG_SHA1 = ${sha1}/" "${S}/stdlib/${name}.version" || die
		else
			cp "${DISTDIR}/${i}" "${S}/deps/srccache/${i#julia-}" || die
		fi
	done
}

src_prepare() {
	default

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths

	sed -i \
		-e "s|git submodule|${EPREFIX}/bin/true|g" \
		-e "s|GENTOOCFLAGS|${CFLAGS}|g" \
		-e "s|/usr/include|${EPREFIX}/usr/include|g" \
		deps/Makefile || die

	sed -i \
		-e "s|GENTOOCFLAGS|${CFLAGS}|g" \
		-e "s|GENTOOLIBDIR|$(get_libdir)|" \
		Make.inc || die

	sed -i \
		-e "s|,lib)|,$(get_libdir))|g" \
		-e "s|\$(BUILD)/lib|\$(BUILD)/$(get_libdir)|g" \
		Makefile || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		src/Makefile || die

	# disable doc install starting	git fetching
	sed -i -e 's~install: $(build_depsbindir)/stringreplace $(BUILDROOT)/doc/_build/html/en/index.html~install: $(build_depsbindir)/stringreplace~' Makefile || die
}

src_configure() {
	# julia does not play well with the system versions of dsfmt, libuv,
	# and utf8proc

	# USE_SYSTEM_LIBM=0 implies using external openlibm
	cat <<-EOF > Make.user
		USE_BINARYBUILDER:=0
		USE_SYSTEM_LLVM:=1
		USE_SYSTEM_LIBUNWIND:=1
		USE_SYSTEM_PCRE:=1
		USE_SYSTEM_LIBM:=0
		USE_SYSTEM_OPENLIBM:=1
		USE_SYSTEM_DSFMT:=0
		USE_SYSTEM_BLAS:=1
		USE_SYSTEM_LAPACK:=1
		USE_SYSTEM_GMP:=1
		USE_SYSTEM_MPFR:=1
		USE_SYSTEM_SUITESPARSE:=1
		USE_SYSTEM_LIBUV:=0
		USE_SYSTEM_UTF8PROC:=0
		USE_SYSTEM_MBEDTLS:=1
		USE_SYSTEM_LIBSSH2:=1
		USE_SYSTEM_CURL:=1
		USE_SYSTEM_PATCHELF:=1
		USE_SYSTEM_ZLIB:=1
		USE_SYSTEM_P7ZIP:=1
		VERBOSE=1
		libdir="${EROOT}/usr/$(get_libdir)"
	EOF
}

src_compile() {

	# Julia accesses /proc/self/mem on Linux
	addpredict /proc/self/mem

	emake julia-release \
		prefix="${EPREFIX}/usr" DESTDIR="${D}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)"
	pax-mark m "$(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')"
	emake
}

src_test() {
	emake test
}

src_install() {
	emake install \
		prefix="${EPREFIX}/usr" DESTDIR="${D}" \
		CC="$(tc-getCC)" CXX="$(tc-getCXX)"

	dodoc README.md

	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
	rmdir "${ED}"/usr/etc || die
	mv "${ED}"/usr/share/doc/julia/html "${ED}"/usr/share/doc/${PF} || die
	rmdir "${ED}"/usr/share/doc/julia || die
}
