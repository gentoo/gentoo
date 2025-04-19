# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: wine.eclass
# @MAINTAINER:
# Wine <wine@gentoo.org>
# @AUTHOR:
# Ionen Wolkens <ionen@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions for app-emuluation/wine-* ebuilds
# @DESCRIPTION:
# Given the large amount of Wine ebuilds (and variants) that need
# duplicated code, this is used to offload the more complex bits
# (primarily toolchain and slotting) and leave ebuilds to only need
# to deal with dependencies and configure options like any other.
#
# Note to overlays: this can be used to package other variants of
# Wine, but there is currently no garantee that eclass changes may
# not break these ebuilds now and then without real warnings

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_WINE_ECLASS} ]]; then
_WINE_ECLASS=1

inherit autotools flag-o-matic multilib prefix toolchain-funcs wrapper

# @ECLASS_VARIABLE: WINE_USEDEP
# @DESCRIPTION:
# Meant be used like multilib-build.eclass' MULTILIB_USEDEP.  Handled
# specially here given Wine ebuilds are not *really* multilib and are
# abusing abi_x86_* with some specific requirements.
#
# TODO: when the *new* wow64 mode (aka USE=wow64) is mature enough to
# be preferred over abi_x86_32, this should be removed and support for
# 32bit-only-on-64bit be dropped matching how /no-multilib/ handles it
readonly WINE_USEDEP="abi_x86_32(-)?,abi_x86_64(-)?"

IUSE="
	+abi_x86_32 +abi_x86_64 crossdev-mingw custom-cflags
	+mingw +strip wow64
"
REQUIRED_USE="
	|| ( abi_x86_32 abi_x86_64 arm64 )
	crossdev-mingw? ( mingw )
	wow64? ( abi_x86_64 !abi_x86_32 )
"

BDEPEND="
	|| (
		sys-devel/binutils:*
		llvm-core/lld:*
	)
	dev-lang/perl
	mingw? (
		!crossdev-mingw? (
			dev-util/mingw64-toolchain[${WINE_USEDEP}]
			wow64? ( dev-util/mingw64-toolchain[abi_x86_32] )
		)
	)
	!mingw? (
		llvm-core/clang:*[${WINE_USEDEP}]
		strip? ( llvm-core/llvm:* )
	)
"
IDEPEND=">=app-eselect/eselect-wine-2"

# @ECLASS_VARIABLE: WINE_SKIP_INSTALL
# @DESCRIPTION:
# Array of files to delete from the installation relative
# to ${ED}, must be set before running wine_src_install.
WINE_SKIP_INSTALL=()

# @FUNCTION: wine_pkg_pretend
# @DESCRIPTION:
# Verifies if crossdev-mingw is used properly, ignored if
# ``MINGW_BYPASS`` is set.
wine_pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local arches=(
			$(usev abi_x86_64 x86_64)
			$(usev abi_x86_32 i686)
			$(usev wow64 i686)
			$(usev arm64 aarch64)
		)

		local mingw
		for mingw in "${arches[@]/%/-w64-mingw32}"; do
			if ! type -P ${mingw}-gcc >/dev/null; then
				eerror "With USE=crossdev-mingw, you must prepare the MinGW toolchain"
				eerror "yourself by installing sys-devel/crossdev then running:"
				eerror
				eerror "    crossdev --target ${mingw}"
				eerror
				eerror "For more information, please see: https://wiki.gentoo.org/wiki/Mingw"
				die "USE=crossdev-mingw is enabled, but ${mingw}-gcc was not found"
			fi
		done
	fi
}

# @FUNCTION: wine_src_prepare
# @DESCRIPTION:
# Apply various minor adjustments, run eautoreconf, make_requests, and
# perform a version mismatch sanity check if WINE_GECKO and WINE_MONO
# are set.
#
# If need more than make_requests, it should be either handled in
# the ebuild or (for users) optionally through portage hooks, e.g.
#
# @CODE
# echo "post_src_prepare() { tools/make_specfiles || die; }" \
#    > /etc/portage/env/app-emulation/wine-vanilla
# @CODE
wine_src_prepare() {
	default

	if [[ ${WINE_GECKO} && ${WINE_MONO} ]]; then
		# sanity check, bumping these has a history of oversights
		local geckomono=$(sed -En '/^#define (GECKO|MONO)_VER/{s/[^0-9.]//gp}' \
			dlls/appwiz.cpl/addons.c || die)

		if [[ ${WINE_GECKO}$'\n'${WINE_MONO} != "${geckomono}" ]]; then
			local gmfatal=
			has live ${PROPERTIES} && gmfatal=nonfatal
			${gmfatal} die -n "gecko/mono mismatch in ebuild, has: " ${geckomono} " (please file a bug)"
		fi
	fi

	if tc-is-clang && use mingw; then
		# -mabi=ms was ignored by <clang:16 then turned error in :17
		# if used without --target *-windows, then gets used in install
		# phase despite USE=mingw, drop as a quick fix for now
		sed -i '/MSVCRTFLAGS=/s/-mabi=ms//' configure.ac || die
	fi

	# ensure .desktop calls this variant + slot
	sed -i "/^Exec=/s/wine /${P} /" loader/wine.desktop || die

	# needed to find wine-mono on prefix
	hprefixify -w /get_mono_path/ dlls/mscoree/metahost.c

	# always update for patches (including user's wrt #432348)
	eautoreconf
	tools/make_requests || die # perl
}

# @FUNCTION: wine_src_configure
# @DESCRIPTION:
# Setup toolchain and run ./configure by passing the ``wineconfargs``
# array.
#
# The following options are handled automatically and do not need
# to be passed: --prefix (and similar), --enable-archs, --enable-win64
# --with-mingw, and --with-wine64
#
# Not truly supported, but cross toolchain can be customised using
# CROSSCC, CROSSCC_amd64/x86/arm64, CROSSCFLAGS and CROSSLDFLAGS
# (based on what wine's configure also recognize, or used to for CC).
wine_src_configure() {
	WINE_PREFIX=/usr/lib/${P}
	WINE_DATADIR=/usr/share/${P}
	WINE_INCLUDEDIR=/usr/include/${P}

	local conf=(
		--prefix="${EPREFIX}"${WINE_PREFIX}
		--datadir="${EPREFIX}"${WINE_DATADIR}
		--includedir="${EPREFIX}"${WINE_INCLUDEDIR}
		--libdir="${EPREFIX}"${WINE_PREFIX}
		--mandir="${EPREFIX}"${WINE_DATADIR}/man
	)

	# strip-flags due to being generally fragile
	use custom-cflags || strip-flags

	# longstanding failing to build with lto, filter unconditionally
	filter-lto

	# may segfault at runtime if used (bug #931329)
	filter-flags -Wl,--gc-sections

	# avoid gcc-15's c23 default for now (bug #943849)
	# TODO: verify if still needed and limit to old until cleanup
	append-cflags -std=gnu17

	# Wine uses many linker tricks that are unlikely to work
	# with anything but bfd or lld (bug #867097)
	if ! tc-ld-is-bfd && ! tc-ld-is-lld; then
		has_version -b sys-devel/binutils &&
			append-ldflags -fuse-ld=bfd ||
			append-ldflags -fuse-ld=lld
		strip-unsupported-flags
	fi

	if use mingw; then
		conf+=( --with-mingw )

		use !crossdev-mingw &&
			! has_version -b 'dev-util/mingw64-toolchain[bin-symlinks]' &&
			PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

		# TODO?: llvm-mingw support if ever packaged and wanted
		local wcc_amd64=${CROSSCC:-${CROSSCC_amd64:-x86_64-w64-mingw32-gcc}}
		local wcc_x86=${CROSSCC:-${CROSSCC_x86:-i686-w64-mingw32-gcc}}
		# no mingw64-toolchain ~arm64, but "may" be usable with crossdev
		# (aarch64- rather than arm64- given it is what Wine searches for)
		local wcc_arm64=${CROSSCC:-${CROSSCC_arm64:-aarch64-w64-mingw32-gcc}}
		local -n wcc_test=wcc_$(usex arm64 arm64 $(usex abi_x86_64 amd64 x86))
	else
		conf+=( --with-mingw=clang )

		# not building for ${CHOST} so $(tc-getCC) is not quite right, but
		# *should* support -target *-windows regardless
		tc-is-clang && local clang=$(tc-getCC) || local clang=clang
		local wcc_amd64=${CROSSCC:-${CROSSCC_amd64:-${clang}}}
		local wcc_x86=${CROSSCC:-${CROSSCC_x86:-${clang}}}
		local wcc_arm64=${CROSSCC:-${CROSSCC_arm64:-${clang}}}
		local wcc_test="${clang} -target $(usex arm64 aarch64 $(usex abi_x86_64 x86_64 i386))-windows"

		# do not copy from regular LDFLAGS given odds are they all are
		# incompatible, and difficult to test linking without llvm-mingw
		: "${CROSSLDFLAGS:= }"
	fi

	conf+=(
		ac_cv_prog_x86_64_CC="${wcc_amd64}"
		ac_cv_prog_i386_CC="${wcc_x86}"
		ac_cv_prog_aarch64_CC="${wcc_arm64}"

		CROSSCFLAGS="${CROSSCFLAGS:-$(
			# many hardening options are unlikely to work right
			filter-flags '-fstack-protector*' #870136
			filter-flags '-mfunction-return=thunk*' #878849

			# bashrc-mv users often do CFLAGS="${LDFLAGS}" and then
			# compile-only tests miss stripping unsupported linker flags
			filter-flags '-Wl,*'

			# -mavx with mingw-gcc has a history of problems and still see
			# users have issues despite Wine's -mpreferred-stack-boundary=2
			use mingw && append-cflags -mno-avx

			CC=${wcc_test} test-flags-CC ${CFLAGS:--O2}
		)}"
		CROSSLDFLAGS="${CROSSLDFLAGS:-$(
			# let compiler figure out the right linker for cross
			filter-flags '-fuse-ld=*'

			CC=${wcc_test} test-flags-CCLD ${LDFLAGS}
		)}"
	)

	if use abi_x86_64 && use abi_x86_32 && use !wow64; then
		# multilib dual build method for "old" wow64 (must do 64 first)
		local bits
		for bits in 64 32; do
		(
			einfo "Configuring for ${bits}bits in ${WORKDIR}/build${bits} ..."

			mkdir ../build${bits} || die
			cd ../build${bits} || die

			if (( bits == 64 )); then
				conf+=( --enable-win64 )
			else
				conf+=(
					--with-wine64=../build64
					TARGETFLAGS=-m32 # for widl
				)

				# optional, but prefer over Wine's auto-detect (+#472038)
				multilib_toolchain_setup x86
			fi

			ECONF_SOURCE=${S} econf "${conf[@]}" "${wineconfargs[@]}"
		)
		done
	else
		# new --enable-archs method, or 32bit-only
		local archs=(
			$(usev abi_x86_64 x86_64)
			$(usev wow64 i386) # 32-on-64bit "new" wow64
			$(usev arm64 aarch64)
		)
		conf+=( ${archs:+--enable-archs="${archs[*]}"} )

		econf "${conf[@]}" "${wineconfargs[@]}"
	fi
}

# @FUNCTION: wine_src_compile
# @DESCRIPTION:
# Handle running emake.
wine_src_compile() {
	if use abi_x86_64 && use abi_x86_32 && use !wow64; then
		emake -C ../build64 # do first
		emake -C ../build32
	else
		emake
	fi
}

# @FUNCTION: wine_src_install
# @DESCRIPTION:
# Handle running emake install, creating slot wrappers, and
# stripping binaries built for Windows.
wine_src_install() {
	if use abi_x86_64 && use abi_x86_32 && use !wow64; then
		emake DESTDIR="${D}" -C ../build32 install
		emake DESTDIR="${D}" -C ../build64 install # do last
	else
		emake DESTDIR="${D}" install
	fi

	if use abi_x86_64 || use arm64; then
		if ver_test -ge 10.2; then
			# wine64 was removed, but keep a symlink for old scripts
			# TODO: can remove this -e guard eventually, only there to
			# avoid overwriting 9999's wine64 if go into <10.2 commits
			[[ ! -e ${ED}${WINE_PREFIX}/bin/wine64 ]] &&
				dosym wine ${WINE_PREFIX}/bin/wine64
		else
			# <wine-10.2 did not have a unified wine(1) and could miss
			# wine64 or wine depending on USE, ensure both are are there
			if [[ -e ${ED}${WINE_PREFIX}/bin/wine64 && ! -e ${ED}${WINE_PREFIX}/bin/wine ]]; then
				dosym wine64 ${WINE_PREFIX}/bin/wine
				dosym wine64-preloader ${WINE_PREFIX}/bin/wine-preloader
			elif [[ ! -e ${ED}${WINE_PREFIX}/bin/wine64 && -e ${ED}${WINE_PREFIX}/bin/wine ]]; then
				dosym wine ${WINE_PREFIX}/bin/wine64
				dosym wine-preloader ${WINE_PREFIX}/bin/wine64-preloader
			fi
		fi
	fi

	# delete unwanted files if requested, not done directly in ebuilds
	# given must be done after install and before wrappers
	if (( ${#WINE_SKIP_INSTALL[@]} )); then
		rm -- "${WINE_SKIP_INSTALL[@]/#/${ED}}" || die
	fi

	# create variant wrappers for eselect-wine
	local bin
	for bin in "${ED}"${WINE_PREFIX}/bin/*; do
		make_wrapper "${bin##*/}-${P#wine-}" "${bin#"${ED}"}"
	done

	# don't let the package manager try to strip Windows files with
	# potentially the wrong strip executable and instead handle it here
	dostrip -x ${WINE_PREFIX}/wine/{x86_64,i386,aarch64}-windows

	if use strip; then
		ebegin "Stripping Windows binaries"
		if use mingw; then
			: "$(usex arm64 aarch64 $(usex abi_x86_64 x86_64 i686)-w64-mingw32-strip)"
			find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(a\|dll\|exe\)' \
				-exec ${_} --strip-unneeded {} +
		else
			# llvm-strip errors on .a, and CHOST binutils strip could mangle
			find "${ED}"${WINE_PREFIX}/wine/*-windows -regex '.*\.\(dll\|exe\)' \
				-exec llvm-strip --strip-unneeded {} +
		fi
		eend ${?} || die
	fi
}

# @FUNCTION: wine_pkg_postinst
# @DESCRIPTION:
# Provide generic warnings about missing 32bit support,
# and run eselect wine update.
wine_pkg_postinst() {
	if use !abi_x86_32 && use !wow64; then
		ewarn "32bit support is disabled. While 64bit applications themselves will"
		ewarn "work, be warned that it is not unusual that installers or other helpers"
		ewarn "will attempt to use 32bit and fail. If do not want full USE=abi_x86_32,"
		ewarn "note the experimental USE=wow64 can allow 32bit without full multilib."
	fi

	# difficult to tell what is needed from here, but try to warn anyway
	if use abi_x86_32 && { use opengl || use vulkan; }; then
		if has_version 'x11-drivers/nvidia-drivers'; then
			if has_version 'x11-drivers/nvidia-drivers[-abi_x86_32]'; then
				ewarn "x11-drivers/nvidia-drivers is installed but is built without"
				ewarn "USE=abi_x86_32 (ABI_X86=32), hardware acceleration with 32bit"
				ewarn "applications under ${PN} will likely not be usable."
				ewarn "Multi-card setups may need this on media-libs/mesa as well."
			fi
		elif has_version 'media-libs/mesa[-abi_x86_32]'; then
			ewarn "media-libs/mesa seems to be in use but is built without"
			ewarn "USE=abi_x86_32 (ABI_X86=32), hardware acceleration with 32bit"
			ewarn "applications under ${PN} will likely not be usable."
		fi
	fi

	eselect wine update --if-unset || die
}

# @FUNCTION: wine_pkg_postrm
# @DESCRIPTION:
# Run eselect wine update if available.
wine_pkg_postrm() {
	if has_version -b app-eselect/eselect-wine; then
		eselect wine update --if-unset || die
	fi
}

fi

EXPORT_FUNCTIONS pkg_pretend src_prepare src_configure src_compile src_install pkg_postinst pkg_postrm
