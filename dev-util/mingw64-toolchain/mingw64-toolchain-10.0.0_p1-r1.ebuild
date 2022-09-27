# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit edo flag-o-matic multilib-build toolchain-funcs

# Pick versions known to work for Wine and use vanilla for simplicity,
# ideally update only on mingw64-runtime bumps or if there's known issues
# (please report) to avoid rebuilding the entire toolchain too often.
# Do _p1++ rather than revbump if changing without bumping mingw64 itself.
BINUTILS_PV=2.39
GCC_PV=12.2.0
MINGW_PV=$(ver_cut 1-3)

DESCRIPTION="All-in-one mingw64 toolchain intended for building Wine without crossdev"
HOMEPAGE="
	https://www.mingw-w64.org/
	https://gcc.gnu.org/
	https://sourceware.org/binutils/"
SRC_URI="
	mirror://sourceforge/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${MINGW_PV}.tar.bz2
	mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.xz
	mirror://gnu/binutils/binutils-${BINUTILS_PV}.tar.xz"
S="${WORKDIR}"

# l1:binutils+gcc, l2:gcc(libraries), l3:mingw64-runtime
LICENSE="
	GPL-3+
	LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 )
	ZPL BSD BSD-2 ISC LGPL-2+ LGPL-2.1+ MIT public-domain"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="+abi_x86_32 custom-cflags debug"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/mpc:=
	dev-libs/mpfr:=
	sys-libs/zlib:=
	virtual/libiconv"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/mingw64-runtime-10.0.0-tmp-files-clash.patch
	"${FILESDIR}"/gcc-11.3.0-plugin-objdump.patch
	"${FILESDIR}"/gcc-12.2.0-drop-cflags-sed.patch
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

	MWT_D=${T}/root # use ${T} to respect VariableScope for ${D}
	local mwtdir=/usr/lib/${PN}
	local prefix=${EPREFIX}${mwtdir}
	local sysroot=${MWT_D}${prefix}
	local -x PATH=${sysroot}/bin:${PATH}

	use custom-cflags || strip-flags # fancy flags are not realistic here

	local multilib=false
	use abi_x86_32 && use abi_x86_64 && multilib=true

	# global configure flags
	local conf=(
		--build=${CBUILD:-${CHOST}}
		--target=${CTARGET}
		--{doc,info,man}dir=/.skip # let individual packages handle docs
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
	)
	mwt-binutils() {
		# symlink gcc's lto plugin for AR (bug #854516)
		ln -s ../../libexec/gcc/${CTARGET}/${GCC_PV}/liblto_plugin.so \
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
		--with-system-zlib
		--without-isl
		--without-zstd
	)
	${multilib} || conf_gcc+=( --disable-multilib )

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
	)
	mwt-mingw64_headers() { ln -s ${CTARGET} "${sysroot}"/mingw || die; } #419601

	local conf_mingw64_runtime=( --with-crt )
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
				unset AR AS CC CPP CXX LD NM OBJCOPY OBJDUMP RANLIB RC STRIP
				CHOST=${CTARGET}
				filter-flags '-fstack-protector*' #870136
				filter-flags '-fuse-ld=*'
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

		mkdir "${build_dir}" || die
		pushd "${build_dir}" >/dev/null || die

		edo "${conf[@]}"
		emake
		emake DESTDIR="${MWT_D}" install

		declare -f mwt-${id} >/dev/null && edo mwt-${id}
		declare -f mwt-${id}_${2} >/dev/null && edo mwt-${id}_${2}

		popd >/dev/null || die
	}

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
				gcc|gcc-${GCC_PV}|g++|widl) mwt-i686_wrapper -m32;;
				ld|ld.bfd) mwt-i686_wrapper -m i386pe;;
				windres) mwt-i686_wrapper --target=pe-i386;;
				*) ln -s ${bin} ${bin32} || die;;
			esac
		done
		popd >/dev/null || die
	fi

	# portage doesn't know the right strip executable to use for CTARGET
	# and it can lead to .a mangling, notably with 32bit (breaks toolchain)
	dostrip -x ${mwtdir}/{${CTARGET}/lib{,32},lib/gcc/${CTARGET}}

	# ... and instead do it here given this saves ~60MB
	if use !debug; then
		einfo "Stripping ${CTARGET} static libraries ..."
		find "${sysroot}"/{,lib/gcc/}${CTARGET} -type f -name '*.a' \
			-exec ${CTARGET}-strip --strip-unneeded {} + || die
	fi
}

src_install() {
	# use mv over copying given it's ~370MB
	mv "${MWT_D}${EPREFIX}"/* "${ED}" || die

	# gcc handles static libs internally without needing .la
	find "${ED}" -type f -name '*.la' -delete || die
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

	local cross_gcc=cross-$(usex x86 i686 x86_64)-w64-mingw32/gcc
	if has_version ${cross_gcc}; then
		# encourage cleanup given users may not realize if switch by default
		ewarn "${cross_gcc} is installed, note that ${PN}"
		ewarn "is redundant with the *-w64-mingw32/{binutils,gcc,mingw64-runtime}"
		ewarn "packages and optionally only one needs to be kept."
	fi
}
