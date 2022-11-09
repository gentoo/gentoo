# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic llvm pax-utils toolchain-funcs optfeature

# correct versions for stdlibs are in deps/checksums
# for everything else, run with network-sandbox and wait for the crash

# 1.8.2 still sits on LLVM 13, bug: https://bugs.gentoo.org/876184
MY_LLVM_V="13.0.0"
LLVM_MAX_SLOT=13

DESCRIPTION="High-performance programming language for technical computing"
HOMEPAGE="https://julialang.org/"

SRC_URI="https://github.com/JuliaLang/julia/releases/download/v${PV}/${P}-full.tar.gz"
PATCHES=( )

# Huge thanks to Arch Linux developers for the patches.
# Patches form version 1.8.0 also apply to 1.8.2.
archlinux_uri="https://raw.githubusercontent.com/archlinux/svntogit-community/packages/julia/trunk/"
archlinux_patches=(
	074d761f.patch
	ed9851b0.patch
	julia-hardcoded-libs.patch
	julia-libunwind-1.6.patch
	julia-llvm-14.patch
	julia-system-cblas.patch
	make-install-no-build.patch
)
for archlinux_patch in ${archlinux_patches[@]} ; do
	archlinux_patch_name="${PN}-1.8.0-${archlinux_patch}"
	SRC_URI+="
		${archlinux_uri}/${archlinux_patch} -> ${archlinux_patch_name}
	"
	PATCHES+=( "${DISTDIR}/${archlinux_patch_name}" )
done

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+system-llvm"

RDEPEND="
	system-llvm? ( sys-devel/llvm:13=[llvm_targets_NVPTX(-)] )
"
RDEPEND+="
	app-arch/p7zip
	dev-libs/gmp:0=
	dev-libs/libgit2:0
	>=dev-libs/libpcre2-10.23:0=[jit,unicode]
	dev-libs/mpfr:0=
	>=dev-libs/libutf8proc-2.6.1:0=[-cjk]
	>=dev-util/patchelf-0.13
	>=net-libs/mbedtls-2.2
	net-misc/curl[http2,ssh]
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
	>=sci-mathematics/dsfmt-2.2.4
	>=sys-libs/libunwind-1.1:0=
	sys-libs/zlib:0=
	>=virtual/blas-3.6
	virtual/lapack
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	!system-llvm? ( dev-util/cmake )
"

pkg_setup() {
	use system-llvm && llvm_pkg_setup
}

src_unpack() {
	local tounpack=(${A})
	# the main source tree, followed by deps
	unpack "${tounpack[0]}"

	mkdir -p "${S}/deps/srccache/"
	for i in "${tounpack[@]:1}"; do
		cp "${DISTDIR}/${i}" "${S}/deps/srccache/${i#julia-}" || die
	done
}

src_prepare() {
	default

	# Sledgehammer:
	# - prevent fetching of bundled stuff in compile and install phase
	# - respect CFLAGS
	# - respect EPREFIX and Gentoo specific paths

	sed -i \
		-e "\|SHIPFLAGS :=|c\\SHIPFLAGS := ${CFLAGS}" \
		Make.inc || die

	sed -i \
		-e "s|ar -rcs|$(tc-getAR) -rcs|g" \
		src/Makefile || die

	# disable doc install starting	git fetching
	sed -i -e 's~install: $(build_depsbindir)/stringreplace $(BUILDROOT)/doc/_build/html/en/index.html~install: $(build_depsbindir)/stringreplace~' Makefile || die
}

src_configure() {
	# bug #855602
	filter-lto

	use system-llvm && ewarn "You have enabled system-llvm. This is unsupported by upstream and may not work."

	# julia does not play well with the system versions of libuv
	# USE_SYSTEM_LIBM=0 implies using external openlibm
	cat <<-EOF > Make.user
		LOCALBASE:="${EPREFIX}/usr"
		override prefix:="${EPREFIX}/usr"
		override libdir:="\$(prefix)/$(get_libdir)"
		override CC:=$(tc-getCC)
		override CXX:=$(tc-getCXX)
		override AR:=$(tc-getAR)

		BUNDLE_DEBUG_LIBS:=0
		USE_BINARYBUILDER:=0
		USE_SYSTEM_CSL:=1
		USE_SYSTEM_LLVM:=$(usex system-llvm 1 0)
		USE_SYSTEM_LIBUNWIND:=1
		USE_SYSTEM_PCRE:=1
		USE_SYSTEM_LIBM:=0
		USE_SYSTEM_OPENLIBM:=1
		USE_SYSTEM_DSFMT:=1
		USE_SYSTEM_BLAS:=1
		USE_SYSTEM_LAPACK:=1
		USE_SYSTEM_LIBBLASTRAMPOLINE:=0
		USE_SYSTEM_GMP:=1
		USE_SYSTEM_MPFR:=1
		USE_SYSTEM_LIBSUITESPARSE:=1
		USE_SYSTEM_LIBUV:=0
		USE_SYSTEM_UTF8PROC:=1
		USE_SYSTEM_MBEDTLS:=1
		USE_SYSTEM_LIBSSH2:=1
		USE_SYSTEM_NGHTTP2:=1
		USE_SYSTEM_CURL:=1
		USE_SYSTEM_LIBGIT2:=1
		USE_SYSTEM_PATCHELF:=1
		USE_SYSTEM_ZLIB:=1
		USE_SYSTEM_P7ZIP:=1
		VERBOSE:=1
	EOF
}

src_compile() {
	# Julia accesses /proc/self/mem on Linux
	addpredict /proc/self/mem

	default
	pax-mark m "$(file usr/bin/julia-* | awk -F : '/ELF/ {print $1}')"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc README.md

	if ! use system-llvm ; then
		local llvmslot=$(ver_cut 1 ${MY_LLVM_V})
		cp "${S}/usr/lib/libLLVM-${llvmslot}jl.so" "${ED}/usr/$(get_libdir)/julia/" || die
	fi

	mv "${ED}"/usr/etc/julia "${ED}"/etc || die
	rmdir "${ED}"/usr/etc || die
	mv "${ED}"/usr/share/doc/julia/html "${ED}"/usr/share/doc/"${PF}" || die
	rmdir "${ED}"/usr/share/doc/julia || die

	# The appdata directory is deprecated.
	mv "${ED}"/usr/share/{appdata,metainfo}/ || die
}

pkg_postinst() {
	optfeature "Julia Plots" sci-visualization/gr
}
