# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo ninja-utils flag-o-matic toolchain-funcs

MINGW_PV=$(ver_cut 1-3)
LLVM_PV=21.1.0
LLVM_MAJOR=$(ver_cut 1 ${LLVM_PV})

DESCRIPTION="Clang/LLVM based mingw64 toolchain"
HOMEPAGE="
	https://www.mingw-w64.org/
"
SRC_URI="
	https://downloads.sourceforge.net/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${MINGW_PV}.tar.bz2
	https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_PV}/llvm-project-${LLVM_PV}.src.tar.xz
"
S="${WORKDIR}"

LICENSE="
	Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )
	ZPL BSD BSD-2 ISC LGPL-2+ LGPL-2.1+ MIT public-domain
"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+arm64ec-pe custom-cflags +strip"

PATCHES="
	${FILESDIR}/${PN}-13.0.0-r1-exclude-arm64-cflags.patch
"

BDEPEND="
	dev-build/cmake
"

RDEPEND="
	llvm-core/clang:${LLVM_MAJOR}
	llvm-core/llvm:${LLVM_MAJOR}
	llvm-core/lld:${LLVM_MAJOR}
"
DEPEND="${RDEPEND}"

# Stripping arm64ec archives breaks them.
# Nothing we install can be stripped by host tools, so just skip everything.
RESTRICT="strip"

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	tc-is-cross-compiler &&
		die "cross-compilation of the toolchain itself is unsupported"
}

pkg_setup() {
	HOSTS=(
		aarch64-w64-mingw32
#		$(usev i686-pe i686-w64-mingw32)
		$(usev arm64ec-pe arm64ec-w64-mingw32)
	)
}

src_prepare() {
	# rename directories to simplify both patching and the ebuild
	mv mingw-w64-v${MINGW_PV} mingw64 || die
	mv llvm-project-${LLVM_PV}.src llvm-project || die
	default

	pushd mingw64 >/dev/null || die
	eautoreconf
	popd >/dev/null || die
}

src_compile() {
	# not great but do everything in src_compile given bootstrapping
	# process needs to be done in steps of configure+compile+install
	# (done modular to have most package-specific things in one place)

	MWT_D=${T}/root # moved to ${D} in src_install
	mwtdir=/usr/lib/${PN}
	prefix=${EPREFIX}${mwtdir}
	sysroot=${MWT_D}${prefix}
	PATH=${sysroot}/bin:${PATH}

	unset AR CC CPP CXX DLLTOOL LD NM OBJCOPY OBJDUMP RANLIB RC STRIP

	export AR=llvm-ar
	export CC=clang
	export CXX=clang++
	export DLLTOOL=llvm-dlltool
	export NM=llvm-nm
	export RANLIB=llvm-ranlib
	export RC=llvm-windres
	export STRIP=llvm-strip

	filter-flags '-fuse-ld=*'
	filter-flags '-mfunction-return=thunk*' #878849

	use custom-cflags || filter-flags '-fstack-protector*' #931512

	filter-flags '-Wl,-z,*'
	append-flags -mno-avx

	filter-lto # requires setting up, and may be messy with mingw static libs
	use custom-cflags || strip-flags # fancy flags are not realistic here

	local -A lib_hosts=(
		aarch64-w64-mingw32 "--disable-lib32 --disable-lib64 --enable-libarm64"
		arm64ec-w64-mingw32 "--disable-lib32 --disable-lib64 --enable-libarm64"
		i686-w64-mingw32 "--enable-lib32 --disable-lib64 --disable-libarm64"
	)
	for CHOST in ${HOSTS[@]}; do
		( per_host_compile ${lib_hosts[${CHOST}]} )

		# portage doesn't know the right strip executable to use for CTARGET
		# and it can lead to .a mangling, notably with 32bit (breaks toolchain)
		dostrip -x ${mwtdir}/${CHOST}/lib{,32}
		dostrip -x /usr/lib/llvm/${LLVM_MAJOR}/${CHOST}/lib/lib{c++,unwind}.dll.a
	done
}

per_host_compile() {
	CC="${CC} -target ${CHOST}" \
	  CXX="${CXX} -target ${CHOST}" \
	  LD="${LD} -target ${CHOST}" \
	  strip-unsupported-flags

	local conf_mingw64=(
		--build=${CBUILD}
		--prefix="${prefix}"/${CHOST}
		--host=${CHOST}
		--with-sysroot=no
		--without-{crt,headers}

		# mingw .dll aren't used by wine and packages wouldn't find them
		# at runtime, use crossdev if need dll and proper search paths
		--disable-shared
	)

	local conf_mingw64_headers=(
		--enable-idl
		--with-headers
	)

	local conf_mingw64_runtime=(
		--with-crt $@
	)

	local conf_mingw64_libraries=( --with-libraries="winpthreads" )

	mwt-build() {
		local id=${1##*/}
		local build_dir=${WORKDIR}/${1}${2+_${2}}-${CHOST}-build

		# econf is not allowed in src_compile and its defaults are
		# mostly unused here, so use configure directly
		local conf=( "${WORKDIR}/${1}"/configure )

		local -n conf_id=conf_${id} conf_id2=conf_${id}_${2}
		[[ ${conf_id@a} == *a* ]] && conf+=( "${conf_id[@]}" )
		[[ ${2} && ${conf_id2@a} == *a* ]] && conf+=( "${conf_id2[@]}" )

		einfo "Building ${id}${2+ ${2}} in ${build_dir} ..."

		mkdir -p "${build_dir}" || die
		pushd "${build_dir}" >/dev/null || die

		edo "${conf[@]}"
		emake MAKEINFO=: V=1
		# -j1 to match bug #906155, other packages may be fragile too
		emake -j1 MAKEINFO=: V=1 DESTDIR="${MWT_D}" install

		popd >/dev/null || die
	}

	cmake-build() {
		local id1=${1/-/_}
		local id2=${2/-/_}
		local -n conf_id=conf_${id1} conf_id2=conf_${id1}_${id2}
		local conf=( "${conf_id[@]}" )
		[[ ${2} && ${conf_id2@a} == *a* ]] && conf+=( "${conf_id2[@]}" )
		local build_dir=${WORKDIR}/${1}${2+_${2}}-${CHOST}-build

		mkdir "${build_dir}" || die
		pushd "${build_dir}" >/dev/null || die
		cmake -GNinja \
			  "${conf[@]}" "${WORKDIR}/$1/$2" || die
		eninja
		DESTDIR="${MWT_D}" eninja install
		popd >/dev/null || die
	}

	CPPFLAGS="$CPPFLAGS --no-default-config -target ${CHOST}"
	mwt-build mingw64 headers
	CPPFLAGS="$CPPFLAGS -isystem ${MWT_D}${prefix}/${CHOST}/include"
	export RCFLAGS="$RCFLAGS -I${MWT_D}${prefix}/${CHOST}/include"
	LDFLAGS="$LDFLAGS --no-default-config -fuse-ld=lld"
	CPP="clang --no-default-config -E -target ${CHOST}" mwt-build mingw64 runtime
	local resource_dir="${T}/resource-dir-${CHOST}"
	cp -a "${BROOT}/usr/lib/clang/${LLVM_MAJOR}" "${resource_dir}" || die
	LDFLAGS="$LDFLAGS -rtlib=compiler-rt -stdlib=libc++ -L${MWT_D}${prefix}/${CHOST}/lib"
	CPPFLAGS="$CPPFLAGS -resource-dir ${resource_dir}"
	local conf_llvm_project=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_C_COMPILER=clang
		-DCMAKE_CXX_COMPILER=clang++
		-DCMAKE_SYSTEM_NAME=Windows
		-DCMAKE_C_COMPILER_WORKS=1
		-DCMAKE_CXX_COMPILER_WORKS=1
		-DCMAKE_C_COMPILER_TARGET="${CHOST}"
		-DCMAKE_ASM_COMPILER_TARGET="${CHOST}"
		-DCMAKE_CXX_COMPILER_TARGET="${CHOST}"
		-DCMAKE_C_FLAGS_INIT="${CPPFLAGS}"
		-DCMAKE_CXX_FLAGS_INIT="${CPPFLAGS}"
	)
	local comp_rt_install="${EPREFIX}/usr/lib/clang/${LLVM_MAJOR}"
	local conf_llvm_project_compiler_rt=(
		-DCOMPILER_RT_INSTALL_PATH="${comp_rt_install}"
		-DCOMPILER_RT_BUILD_BUILTINS=TRUE
		-DCOMPILER_RT_DEFAULT_TARGET_ONLY=TRUE
		-DCOMPILER_RT_EXCLUDE_ATOMIC_BUILTIN=FALSE
		-DLLVM_CONFIG_PATH=""
		-DCMAKE_FIND_ROOT_PATH="${prefix}/${CHOST}"
		-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY
		-DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY
		-DCOMPILER_RT_BUILD_SANITIZERS=FALSE
		-DCOMPILER_RT_BUILD_CTX_PROFILE=FALSE
		-DCOMPILER_RT_BUILD_XRAY=FALSE
		-DCOMPILER_RT_BUILD_ORC=FALSE
		-DCOMPILER_RT_BUILD_PROFILE=FALSE
		-DCOMPILER_RT_BUILD_MEMPROF=FALSE
		-DCOMPILER_RT_BUILD_LIBFUZZER=FALSE
	)
	local conf_llvm_project_runtimes=(
		-DLLVM_ENABLE_RUNTIMES="libunwind;libcxxabi;libcxx"
		-DLLVM_DEFAULT_TARGET_TRIPLE="${CHOST}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/${CHOST}"
		-DLIBUNWIND_USE_COMPILER_RT=TRUE
		-DLIBUNWIND_ENABLE_SHARED=TRUE
		-DLIBCXX_USE_COMPILER_RT=TRUE
		-DLIBCXX_ENABLE_SHARED=TRUE
		-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=TRUE
		-DLIBCXX_CXX_ABI=libcxxabi
		-DLIBCXX_LIBDIR_SUFFIX=""
		-DLIBCXX_INCLUDE_TESTS=FALSE
		-DLIBCXX_INSTALL_MODULES=TRUE
		-DLIBCXX_ENABLE_ABI_LINKER_SCRIPT=FALSE
		-DLIBCXXABI_USE_COMPILER_RT=TRUE
		-DLIBCXXABI_USE_LLVM_UNWINDER=TRUE
		-DLIBCXXABI_ENABLE_SHARED=OFF
		-DLIBCXXABI_LIBDIR_SUFFIX=""
	)

	cmake-build llvm-project compiler-rt
	if [[ $CHOST == arm64ec-w64-mingw32 ]]; then
		base="${MWT_D}/${comp_rt_install}/lib/windows"
		llvm-ar -qL "${base}/libclang_rt.builtins-aarch64.a" "${base}/libclang_rt.builtins-arm64ec.a"
	fi
	cp -a "${MWT_D}/${comp_rt_install}"/* "${resource_dir}/" || die

	cmake-build llvm-project runtimes

	mwt-build mingw64 libraries
}

src_install() {
	mv -- "${MWT_D}${EPREFIX}"/* "${ED}" || die

	find "${ED}" -type f -name '*.la' -delete || die
	bindir="${ED}/usr/lib/llvm-mingw64/bin"
	mkdir -p "${bindir}" || die
	mkdir -p "${ED}/etc/clang/${LLVM_MAJOR}" || die

	for CHOST in ${HOSTS[@]}; do
		( per_host_install )
	done
}

per_host_install() {
	local cchost="${CHOST/mingw32/windows-gnu}"
	for bin in clang clang++; do
		ln -s "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/${bin}" "${bindir}/${CHOST}-${bin}" || die
		echo "@${cchost}-common.cfg" >"${ED}/etc/clang/${LLVM_MAJOR}/${cchost}-${bin}.cfg" || die
	done
	cat >"${ED}/etc/clang/${LLVM_MAJOR}/${cchost}-common.cfg" <<-EOF
	-Xclang=-internal-isystem
	-Xclang=${EPREFIX}/usr/lib/${PN}/${CHOST}/include
	-stdlib=libc++
	-rtlib=compiler-rt
	-unwindlib=libunwind
	-L${EPREFIX}/usr/lib/${PN}/${CHOST}/lib/
	EOF
	for bin in dlltool windres ar; do
		ln -s "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-${bin}" "${bindir}/${CHOST}-${bin}" || die
	done
	ln -s "${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/lld-link" "${bindir}/${CHOST}-ld" || die
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that this package is primarily intended for Wine and related"
		elog "packages to depend on without needing a manual crossdev setup."
		elog
		elog "Settings are oriented only for what these need and simplicity."
		elog "Use sys-devel/crossdev if need full toolchain/customization:"
		elog "    https://wiki.gentoo.org/wiki/Mingw"
		elog "    https://wiki.gentoo.org/wiki/Crossdev"
	fi
}
