# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib wrapper flag-o-matic

DESCRIPTION="7-Zip archiver"
HOMEPAGE="https://www.7-zip.org/"
#MY_PN="7z"
#MY_PV=${PV//./}
#MY_P="${MY_PN}${MY_PV}"
#SRC_DIR_NAME="${MY_P}-src"
#SRC_URI="https://7-zip.org/a/${SRC_DIR_NAME}.7z -> ${P}.7z"
#S="${WORKDIR}"
# Upstream uses .7z compression for sources which produce
# a circular dependency.
# Debian mirror is used here for 7-zip sources.
SRC_DIR_NAME="7zip-upstream-${PV}_alpha"
SRC_URI="https://salsa.debian.org/debian/7zip/-/archive/upstream/${PV}_alpha/${SRC_DIR_NAME}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${SRC_DIR_NAME}"
B_DIR="${WORKDIR}/build"

LICENSE="LGPL-2.1 rar? ( unRAR )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="7z 7za 7zdec 7zr +7zz doc jwasm lto rar sfx static test"
REQUIRED_USE="
    || ( 7z 7za 7zdec 7zr 7zz )
    rar? ( || ( 7z 7zz ) )
    sfx? ( || ( 7z 7za 7zr 7zz ) )
    jwasm? ( || ( amd64 x86 ) )
    static? ( !7z )
"
# Makefiles do not support building of shared lib on macOS,
# which is required for 7z binary
#REQUIRED_USE+="
#    7z ( !ppc-macos !x86-macos !arm64-macos )
#"
RESTRICT="!test? ( test )"

BDEPEND="
    jwasm? ( dev-lang/jwasm )
"
RDEPEND="
    7z? ( !app-arch/p7zip )
    7za? ( !app-arch/p7zip )
    7zr? ( !app-arch/p7zip )
    7zz? ( !app-arch/p7zip )
"

src_prepare() {
	default

	if use jwasm ; then
		# jwasm is too old and does not support new commands used in Aes assembler files
		sed -E -e '/^\$O\/AesOpt\.o: .*\.asm/ { s|/Asm/x86/AesOpt\.asm|/C/AesOpt.c| ;' \
			-e ' n; s|MY_ASM|CC| ; s|AFLAGS|CFLAGS| ; } ' \
			-i C/7zip_gcc_c.mak CPP/7zip/7zip_gcc.mak || die
	fi

	sed -E -e '/^CFLAGS.* = / s/ (-O2|-Werror)\>//g' \
		-e '/\$\(CXX\)/ s| -s\>||' \
		-i C/7zip_gcc_c.mak CPP/7zip/7zip_gcc.mak || die

	if ! use rar ; then
		# Remove RAR codec licensed under unRAR license
		sed -E -e '/RAR_OBJS/d' \
			-e '/\$O\/Rar/d' \
			-i CPP/7zip/Bundles/Format7zF/Arc_gcc.mak || die
		rm -r CPP/7zip/Archive/Rar || die
		rm CPP/7zip/Compress/Rar* || die
	fi
}

src_compile() {
	local emake_args=( )
	local makefile_name
	local emake_args_cpp
	local emake_args_c

	if tc-is-gcc ; then
		makefile_name='cmpl_gcc.mak'
		if ver_test $(gcc-version) -ge 9 ; then
			emake_args+=( CFLAGS_WARN='$(CFLAGS_WARN_GCC_9)' )
		elif ver_test $(gcc-version) -ge 6 ; then
			emake_args+=( CFLAGS_WARN='$(CFLAGS_WARN_GCC_6)' )
		else
			emake_args+=( CFLAGS_WARN='' )
		fi
		if use lto ; then
			append-flags '-fno-strict-aliasing' '-flto=auto'
			append-ldflags $CFLAGS
		fi
	elif tc-is-clang ; then
		makefile_name='cmpl_clang.mak'
		if ver_test $(clang-version) -ge 12 ; then
			emake_args+=( CFLAGS_WARN='$(CFLAGS_WARN_CLANG_12) $(CFLAGS_WARN_1)' )
		elif ver_test $(clang-version) -ge 10 ; then
			emake_args+=( CFLAGS_WARN='$(CFLAGS_WARN_CLANG_3_8) $(CFLAGS_WARN_1)' )
		elif ver_test $(clang-version) -ge 3.8 ; then
			emake_args+=( CFLAGS_WARN='$(CFLAGS_WARN_CLANG_3_8)' )
		else
			emake_args+=( CFLAGS_WARN='' )
		fi
		if use lto ; then
			append-flags '-fno-strict-aliasing' '-flto'
			append-ldflags $CFLAGS
		fi
	else
		if use lto ; then
			eerror "LTO is not supported with $(tc-getCC) compiler"
			die
		fi
		ewarn "$(tc-getCC) compiler is not supported by 7-zip upstream."
		makefile_name='cmpl_gcc.mak'
		emake_args+=( CFLAGS_WARN='' )
	fi
	if use x86 ; then
		emake_args+=( IS_X86=1 )
	fi
	if use amd64 ; then
		emake_args+=( IS_X64=1 )
	fi
	if use arm64 ; then
		emake_args+=( IS_ARM64=1 )
		if tc-is-gcc || tc-is-clang ; then
			# 7-zip uses GAS assembler files for arm64,
			# so assembler is unconditionally enabled
			# as files are processed directly by GCC
			emake_args+=( USE_ASM=1 )
			append-ldflags '-Wl,-z,noexecstack'
		fi
	fi
	if use jwasm ; then
		emake_args+=( USE_ASM=1 MY_ASM=jwasm )
		append-ldflags '-Wl,-z,noexecstack'
	fi
	if use static ; then
		append-ldflags '-static'
	fi

	emake_args+=(
		CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		CFLAGS_BASE2="${CFLAGS}" CXXFLAGS_BASE2="${CXXFLAGS}" \
		LDFLAGS_STATIC="-DNDEBUG ${LDFLAGS}" MY_ARCH=''
	)

	emake_args_cpp=( -f "../../${makefile_name}" "${emake_args[@]}" )
	emake_args_c=( -f "../../../CPP/7zip/${makefile_name}" "${emake_args[@]}" )

	if use 7z ; then
		cd "${S}"/CPP/7zip/UI/Console || die
		emake "${emake_args_cpp[@]}" O="${B_DIR}/7z"

		cd "${S}"/CPP/7zip/Bundles/Format7zF || die
		emake "${emake_args_cpp[@]}" O="${B_DIR}/lib7z"
	fi

	if use 7za ; then
		cd "${S}"/CPP/7zip/Bundles/Alone || die
		emake "${emake_args_cpp[@]}" O="${B_DIR}/7za"
	fi

	if use 7zdec ; then
		cd "${S}"/C/Util/7z || die
		emake "${emake_args_c[@]}" O="${B_DIR}/7zdec"
	fi

	if use 7zr ; then
		cd "${S}"/CPP/7zip/Bundles/Alone7z || die
		emake "${emake_args_cpp[@]}" O="${B_DIR}/7zr"
	fi

	if use 7zz || use test ; then
		cd "${S}"/CPP/7zip/Bundles/Alone2 || die
		emake "${emake_args_cpp[@]}" O="${B_DIR}/7zz"
	fi

	if use sfx ; then
		cd "${S}"/CPP/7zip/Bundles/SFXCon || die
		emake "${emake_args_cpp[@]}" PROG=7zCon.sfx O="${B_DIR}/7zSFX"
	fi
}

src_test() {
	# Run benchmark as a test
	"${B_DIR}/7zz/7zz" b '-mm=*' '-mmt=*' -bt || die
}

src_install() {
	local app_lib_dir="/usr/$(get_libdir)/7zip"

	cd "${B_DIR}" || die

	if use 7z ; then
		exeinto "${app_lib_dir}"
		doexe 7z/7z lib7z/7z.so
		# 7z binary must by called with the full path
		# otherwise it wil unable to find 7z.so
		make_wrapper 7z "${app_lib_dir}/7z"
	fi

	if use sfx ; then
		exeinto "${app_lib_dir}"
		doexe 7zSFX/7zCon.sfx
	
		# To be able to find SFX module, 7zip binaries
		# must be called with the full path
		if use 7za ; then
			doexe 7za/7za
			make_wrapper 7za "${app_lib_dir}/7za"
		fi
		if use 7zr ; then
			doexe 7zr/7zr
			make_wrapper 7zr "${app_lib_dir}/7zr"
		fi
		if use 7zz ; then
			doexe 7zz/7zz
			make_wrapper 7zz "${app_lib_dir}/7zz"
		fi
	else
		use 7za && dobin 7za/7za
		use 7zr && dobin 7zr/7zr
		use 7zz && dobin 7zz/7zz
	fi

	use 7zdec && dobin 7zdec/7zdec

	use 7zz && use !7z && dosym 7zz /usr/bin/7z

	use doc && dodoc "${S}"/DOC/*.txt
}
