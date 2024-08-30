# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit edo flag-o-matic multilib-build toolchain-funcs

# Pick versions known to work for wine+dxvk, and avoid too frequent updates
# due to slow rebuilds. Do _p1++ rather than revbump on changes (not using
# Gentoo patchsets for simplicity, their changes are mostly unneeded here).
BINUTILS_PV=2.42
GCC_PV=14.1.0
MINGW_PV=$(ver_cut 1-3)

DESCRIPTION="All-in-one mingw64 toolchain intended for building Wine without crossdev"
HOMEPAGE="
	https://www.mingw-w64.org/
	https://gcc.gnu.org/
	https://sourceware.org/binutils/
"
SRC_URI="
	https://downloads.sourceforge.net/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${MINGW_PV}.tar.bz2
	mirror://gnu/binutils/binutils-${BINUTILS_PV}.tar.xz
"
if [[ ${GCC_PV} == *-* ]]; then
	SRC_URI+=" mirror://gcc/snapshots/${GCC_PV}/gcc-${GCC_PV}.tar.xz"
else
	SRC_URI+="
		mirror://gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.xz
		mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.xz
	"
fi
S="${WORKDIR}"

# l1:binutils+gcc, l2:gcc(libraries), l3:mingw64-runtime
LICENSE="
	GPL-3+
	LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 )
	ZPL BSD BSD-2 ISC LGPL-2+ LGPL-2.1+ MIT public-domain
"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="+abi_x86_32 bin-symlinks custom-cflags +strip"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/mpc:=
	dev-libs/mpfr:=
	sys-libs/zlib:=
	virtual/libiconv
	bin-symlinks? (
		abi_x86_64? (
			!cross-x86_64-w64-mingw32/binutils
			!cross-x86_64-w64-mingw32/gcc
		)
		abi_x86_32? (
			!cross-i686-w64-mingw32/binutils
			!cross-i686-w64-mingw32/gcc
		)
	)
"
DEPEND="${RDEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	strerror_r # libstdc++ test using -Wimplicit+error
)

PATCHES=(
	"${FILESDIR}"/gcc-12.2.0-drop-cflags-sed.patch
	"${FILESDIR}"/gcc-14.1.0-no-omit-fp-ice.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	tc-is-cross-compiler &&
		die "cross-compilation of the toolchain itself is unsupported"
}

src_prepare() {
	# rename directories to simplify both patching and the ebuild
	mv binutils{-${BINUTILS_PV},} || die
	mv gcc{-${GCC_PV},} || die
	mv mingw-w64-v${MINGW_PV} mingw64 || die

	default
}

src_compile() {
	# not great but do everything in src_compile given bootstrapping
	# process needs to be done in steps of configure+compile+install
	# (done modular to have most package-specific things in one place)

	CTARGET=$(usex x86 i686 x86_64)-w64-mingw32

	MWT_D=${T}/root # moved to ${D} in src_install
	local mwtdir=/usr/lib/${PN}
	local prefix=${EPREFIX}${mwtdir}
	local sysroot=${MWT_D}${prefix}
	local -x PATH=${sysroot}/bin:${PATH}

	filter-lto # requires setting up, and may be messy with mingw static libs
	use custom-cflags || strip-flags # fancy flags are not realistic here

	local multilib=false
	use abi_x86_32 && use abi_x86_64 && multilib=true

	# global configure flags
	local conf=(
		--build=${CBUILD:-${CHOST}}
		--target=${CTARGET}
		--{doc,info,man}dir=/.skip # let the real binutils+gcc handle docs
		MAKEINFO=: #922230
	)

	# binutils
	local conf_binutils=(
		--prefix="${prefix}"
		--host=${CHOST}
		--disable-cet
		--disable-default-execstack
		--disable-nls
		--disable-shared
		--with-system-zlib
		--without-debuginfod
		--without-msgpack
		--without-zstd
	)
	mwt-binutils() {
		# symlink gcc's lto plugin for AR (bug #854516)
		ln -s ../../libexec/gcc/${CTARGET}/${GCC_PV%%[.-]*}/liblto_plugin.so \
			"${sysroot}"/lib/bfd-plugins || die
	}

	# gcc (minimal -- if need more, disable only in stage1 / enable in stage3)
	local conf_gcc=(
		--prefix="${prefix}"
		--host=${CHOST}
		--disable-bootstrap
		--disable-cet
		--disable-gcov #843989
		--disable-gomp
		--disable-libquadmath
		--disable-libsanitizer
		--disable-libssp
		--disable-libvtv
		--disable-shared
		--disable-werror
		--with-gcc-major-version-only
		--with-system-zlib
		--without-isl
		--without-zstd
	)
	${multilib} || conf_gcc+=( --disable-multilib )
	# libstdc++ may misdetect sys/sdt.h on systemtap-enabled system and fail
	# (not passed in conf_gcc above given it is lost in sub-configure calls)
	local -x glibcxx_cv_sys_sdt_h=no

	local conf_gcc_stage1=(
		--enable-languages=c
		--disable-libatomic
		--with-sysroot="${sysroot}"
	)
	local -n conf_gcc_stage2=conf_gcc_stage1

	local conf_gcc_stage3=(
		--enable-languages=c,c++
		--enable-threads=posix # needs stage3, and is required for dxvk/vkd3d
		--with-sysroot="${prefix}"
		--with-build-sysroot="${sysroot}"
	)

	# mingw64-runtime (split in several parts, 3 needed for gcc stages)
	local conf_mingw64=(
		--prefix="${prefix}"/${CTARGET}
		--host=${CTARGET}
		--with-sysroot=no
		--without-{crt,headers}

		# mingw .dll aren't used by wine and packages wouldn't find them
		# at runtime, use crossdev if need dll and proper search paths
		--disable-shared
	)

	local conf_mingw64_headers=(
		--enable-idl
		--with-headers

		# ucrt has not been tested and migration needs looking into, force
		# msvcrt-os for now (if really want this either use crossdev or
		# override using MWT_MINGW64_{HEADERS,RUNTIME}_CONF=... env vars)
		--with-default-msvcrt=msvcrt-os
	)
	mwt-mingw64_headers() { ln -s ${CTARGET} "${sysroot}"/mingw || die; } #419601

	local conf_mingw64_runtime=(
		--with-crt
		--with-default-msvcrt=msvcrt-os # match with headers
	)
	${multilib} ||
		conf_mingw64_runtime+=( $(usex x86 --disable-lib64 --disable-lib32 ) )

	local conf_mingw64_libraries=( --with-libraries )
	local conf_mingw64_libraries32=(
		--libdir="${prefix}"/${CTARGET}/lib32
		--with-libraries
		CC="${CTARGET}-gcc -m32"
		RCFLAGS="--target=pe-i386 ${RCFLAGS}"
	)

	# mingw64-runtime's idl compiler (useful not to depend on wine for widl)
	local conf_widl=( --prefix="${prefix}" )

	# mwt-build [-x] <path/package-name> [stage-name]
	# -> ./configure && make && make install && mwt-package() && mwt-package_stage()
	# passes conf, conf_package, and conf_package_stage arrays to configure, and
	# users can add options through environment with e.g.
	#	MWT_BINUTILS_CONF="--some-option"
	#	MWT_GCC_STAGE1_CONF="--some-gcc-stage1-only-option"
	#	MWT_WIDL_CONF="--some-other-option"
	#	EXTRA_ECONF="--global-option" (generic naming for if not reading this)
	mwt-build() {
		if [[ ${1} == -x ]]; then
			(
				# cross-compiling, cleanup and let ./configure handle it
				unset AR AS CC CPP CXX DLLTOOL LD NM OBJCOPY OBJDUMP RANLIB RC STRIP
				CHOST=${CTARGET}
				filter-flags '-fuse-ld=*'
				filter-flags '-mfunction-return=thunk*' #878849

				# support for stack-protector is still new and experimental
				# for mingw and issues can also be harder to debug + fix for
				# upstreams using it, if feeling concerned about security
				# would advise to either not use wine or at least contain it
				use custom-cflags || filter-flags '-fstack-protector*' #931512

				# some bashrc-mv users tend to do CFLAGS="${LDFLAGS}" and then
				# strip-unsupported-flags miss these during compile-only tests
				# (primarily done for 23.0 profiles' -z, not full coverage)
				filter-flags '-Wl,-z,*'

				# -mavx with mingw-gcc has a history of obscure issues and
				# disabling is seen as safer, e.g. `WINEARCH=win32 winecfg`
				# crashes with -march=skylake >=wine-8.10, similar issues with
				# znver4: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110273
				append-flags -mno-avx

				strip-unsupported-flags
				mwt-build "${@:2}"
			)
			return
		fi

		local id=${1##*/}
		local build_dir=${WORKDIR}/${1}${2+_${2}}-build

		# econf is not allowed in src_compile and its defaults are
		# mostly unused here, so use configure directly
		local conf=( "${WORKDIR}/${1}"/configure "${conf[@]}" )

		local -n conf_id=conf_${id} conf_id2=conf_${id}_${2}
		[[ ${conf_id@a} == *a* ]] && conf+=( "${conf_id[@]}" )
		[[ ${2} && ${conf_id2@a} == *a* ]] && conf+=( "${conf_id2[@]}" )

		local -n extra_id=MWT_${id^^}_CONF extra_id2=MWT_${id^^}_${2^^}_CONF
		conf+=( ${EXTRA_ECONF} ${extra_id} ${2+${extra_id2}} )

		einfo "Building ${id}${2+ ${2}} in ${build_dir} ..."

		mkdir -p "${build_dir}" || die
		pushd "${build_dir}" >/dev/null || die

		edo "${conf[@]}"
		emake MAKEINFO=: V=1
		# -j1 to match bug #906155, other packages may be fragile too
		emake -j1 MAKEINFO=: V=1 DESTDIR="${MWT_D}" install

		declare -f mwt-${id} >/dev/null && edo mwt-${id}
		declare -f mwt-${id}_${2} >/dev/null && edo mwt-${id}_${2}

		popd >/dev/null || die
	}

	# workaround race condition with out-of-source crt build (bug #879537)
	mkdir -p mingw64_runtime-build/mingw-w64-crt/lib{32,64} || die

	# build with same ordering that crossdev would do + stage3 for pthreads
	mwt-build binutils
	mwt-build mingw64 headers
	mwt-build gcc stage1
	mwt-build -x mingw64 runtime
	mwt-build gcc stage2
	${multilib} && mwt-build -x mingw64 libraries32
	mwt-build -x mingw64 libraries
	mwt-build gcc stage3
	mwt-build mingw64/mingw-w64-tools/widl
	# note: /could/ system-bootstrap if already installed, but gcc and
	# libraries will use the system's older mingw64 headers/static-libs
	# and make this potentially fragile without more workarounds/stages

	if ${multilib}; then
		# Like system's gcc, `x86_64-w64-mingw32-gcc -m32` can build for x86,
		# but packages expect crossdev's i686-w64-mingw32-gcc which is the same
		# just without 64bit support and would rather not build the toolchain
		# twice. Dirty but wrap to allow simple interoperability with crossdev.
		mwt-i686_wrapper() {
			printf "#!/usr/bin/env sh\nexec \"${prefix}/bin/${bin}\" ${*} "'"${@}"\n' \
				> ${bin32} || die
			chmod +x ${bin32} || die
		}
		pushd "${sysroot}"/bin >/dev/null || die
		local bin bin32
		for bin in ${CTARGET}-*; do
			bin32=${bin/x86_64-w64/i686-w64}
			case ${bin#${CTARGET}-} in
				as) mwt-i686_wrapper --32;;
				cpp|gcc|gcc-${GCC_PV%%[.-]*}|g++|widl) mwt-i686_wrapper -m32;;
				ld|ld.bfd) mwt-i686_wrapper -m i386pe;;
				windres) mwt-i686_wrapper --target=pe-i386;;
				*) ln -s ${bin} ${bin32} || die;;
			esac
		done
		popd >/dev/null || die
	fi

	if use bin-symlinks; then
		mkdir -p -- "${MWT_D}${EPREFIX}"/usr/bin/ || die
		local bin
		for bin in "${sysroot}"/bin/*; do
			ln -rs -- "${bin}" "${MWT_D}${EPREFIX}"/usr/bin/ || die
		done
	fi

	# portage doesn't know the right strip executable to use for CTARGET
	# and it can lead to .a mangling, notably with 32bit (breaks toolchain)
	dostrip -x ${mwtdir}/{${CTARGET}/lib{,32},lib/gcc/${CTARGET}}

	# ... and instead do it here given this saves ~60MB
	if use strip; then
		einfo "Stripping ${CTARGET} static libraries ..."
		find "${sysroot}"/{,lib/gcc/}${CTARGET} -type f -name '*.a' \
			-exec ${CTARGET}-strip --strip-unneeded {} + || die
	fi
}

src_install() {
	mv -- "${MWT_D}${EPREFIX}"/* "${ED}" || die

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	use bin-symlinks && has_version dev-util/shadowman && [[ ! ${ROOT} ]] &&
		eselect compiler-shadow update all

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that this package is primarily intended for Wine and related"
		elog "packages to depend on without needing a manual crossdev setup."
		elog
		elog "Settings are oriented only for what these need and simplicity."
		elog "Use sys-devel/crossdev if need full toolchain/customization:"
		elog "    https://wiki.gentoo.org/wiki/Mingw"
		elog "    https://wiki.gentoo.org/wiki/Crossdev"
	fi

	local cross_gcc=cross-$(usex x86 i686 x86_64)-w64-mingw32/gcc
	if has_version ${cross_gcc}; then
		# encourage cleanup given users may not realize if switch by default
		ewarn "${cross_gcc} is installed, note that ${PN}"
		ewarn "is redundant with the *-w64-mingw32/{binutils,gcc,mingw64-runtime}"
		ewarn "packages and optionally only one needs to be kept."
	fi
}

pkg_postrm() {
	use bin-symlinks && has_version dev-util/shadowman && [[ ! ${ROOT} ]] &&
		eselect compiler-shadow clean all
}
