# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
MULTILIB_ABIS="amd64 x86" # allow usage on /no-multilib/
inherit eapi9-ver flag-o-matic meson multibuild multilib multilib-build python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"
	EGIT_SUBMODULES=(
		# picky about headers and is cross-compiled making -I/usr/include troublesome
		include/{spirv,vulkan}
		subprojects/libdisplay-info
	)
else
	HASH_SPIRV=8b246ff75c6615ba4532fe4fde20f1be090c3764
	HASH_VULKAN=234c4b7370a8ea3239a214c9e871e4b17c89f4ab
	HASH_DISPLAYINFO=275e6459c7ab1ddd4b125f28d0440716e4888078
	SRC_URI="
		https://github.com/doitsujin/dxvk/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/KhronosGroup/SPIRV-Headers/archive/${HASH_SPIRV}.tar.gz
			-> spirv-headers-${HASH_SPIRV}.tar.gz
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${HASH_VULKAN}.tar.gz
			-> vulkan-headers-${HASH_VULKAN}.tar.gz
		https://gitlab.freedesktop.org/JoshuaAshton/libdisplay-info/-/archive/${HASH_DISPLAYINFO}/libdisplay-info-${HASH_DISPLAYINFO}.tar.bz2
	"
	KEYWORDS="-* ~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Vulkan-based implementation of D3D9, D3D10 and D3D11 for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk/"

# setup_dxvk.sh is no longer provided, fetch old until a better solution
SRC_URI+=" https://raw.githubusercontent.com/doitsujin/dxvk/cd21cd7fa3b0df3e0819e21ca700b7627a838d69/setup_dxvk.sh"

LICENSE="ZLIB Apache-2.0 MIT"
SLOT="0"
IUSE="+abi_x86_32 crossdev-mingw +d3d8 +d3d9 +d3d10 +d3d11 +dxgi +i686-pe +strip"
REQUIRED_USE="
	!arm64? ( || ( abi_x86_32 abi_x86_64 ) )
	|| ( d3d8 d3d9 d3d10 d3d11 dxgi )
	d3d8? ( d3d9 )
	d3d10? ( d3d11 )
	d3d11? ( dxgi )
"

DXVK_USEDEP="abi_x86_32(-)?,abi_x86_64(-)?"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glslang
	!arm64? ( !crossdev-mingw? ( dev-util/mingw64-toolchain[${DXVK_USEDEP}] ) )
	arm64? ( dev-util/llvm-mingw64[i686-pe?] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.10.3-wow64-setup.patch
	"${FILESDIR}"/${PN}-2.4-d3d8-setup.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if use crossdev-mingw && [[ ! -v MINGW_BYPASS ]]; then
		local tool=-w64-mingw32-g++
		for tool in $(usev abi_x86_64 x86_64${tool}) $(usev abi_x86_32 i686${tool}); do
			if ! type -P ${tool} >/dev/null; then
				eerror "With USE=crossdev-mingw, it is necessary to setup the mingw toolchain."
				eerror "For instructions, please see: https://wiki.gentoo.org/wiki/Mingw"
				use abi_x86_32 && use abi_x86_64 &&
					eerror "Also, with USE=abi_x86_32, will need both i686 and x86_64 toolchains."
				die "USE=crossdev-mingw is set but ${tool} was not found"
			elif [[ ! $(LC_ALL=C ${tool} -v 2>&1) =~ "Thread model: posix" ]]; then
				eerror "${PN} requires GCC to be built with --enable-threads=posix"
				eerror "Please see: https://wiki.gentoo.org/wiki/Mingw#POSIX_threads_for_Windows"
				die "USE=crossdev-mingw is set but ${tool} does not use POSIX threads"
			fi
		done
	fi
}

winedll_toolchain_setup() {
	local -A abi_to_chost=(
		[arm64]=aarch64-w64-mingw32
		[x86]=i686-w64-mingw32
	)
	CHOST=${abi_to_chost[$1]}
	CC=${CHOST}-clang
	CXX=${CHOST}-clang++
	RC=${CHOST}-windres
	AR=${CHOST}-ar
	STRIP=llvm-strip
}

winedll_multibuild_wrapper() {
	local ABI=${MULTIBUILD_VARIANT#*.}
	local -r MULTILIB_ABI_FLAG=${MULTIBUILD_VARIANT%.*}

	use !arm64 && multilib_toolchain_setup "${ABI}"
	use arm64 && winedll_toolchain_setup "${ABI}"
	readonly ABI

	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	"${@}"
	popd >/dev/null || die
}

winedll_foreach_abi() {
	local MULTIBUILD_VARIANTS
	use arm64 && MULTIBUILD_VARIANTS=(
			$(usex i686-pe i686-pe.x86)
			arm64.arm64
		)
	use !arm64 && MULTIBUILD_VARIANTS=( $(multilib_get_enabled_abi_pairs) )
	multibuild_foreach_variant winedll_multibuild_wrapper "${@}"
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		rmdir include/{spirv,vulkan} subprojects/libdisplay-info || die
		mv ../SPIRV-Headers-${HASH_SPIRV} include/spirv || die
		mv ../Vulkan-Headers-${HASH_VULKAN} include/vulkan || die
		mv ../libdisplay-info-${HASH_DISPLAYINFO} subprojects/libdisplay-info || die
	fi
	cp -- "${DISTDIR}"/setup_dxvk.sh . || die

	default

	sed -i "/^basedir=/s|=.*|=${EPREFIX}/usr/lib/${PN}|" setup_dxvk.sh || die
}

src_configure() {
	use !arm64 && use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}
	use arm64 && PATH=${BROOT}/usr/lib/llvm-mingw64/bin:${PATH}

	# random segfaults been reported with LTO in some games, filter as
	# a safety (note that optimizing this further won't really help
	# performance, GPU does the actual work)
	filter-lto

	# -mavx and mingw-gcc do not mix safely here
	# https://github.com/doitsujin/dxvk/issues/4746#issuecomment-2708869202
	append-flags -mno-avx

	if [[ ${CHOST} != *-mingw* ]]; then
		if [[ ! -v MINGW_BYPASS ]]; then
			unset AR CC CXX RC STRIP
			filter-flags '-fuse-ld=*'
			filter-flags '-mfunction-return=thunk*' #878849

			# some bashrc-mv users tend to do CFLAGS="${LDFLAGS}" and then
			# strip-unsupported-flags miss these during compile-only tests
			# (primarily done for 23.0 profiles' -z, not full coverage)
			filter-flags '-Wl,-z,*' #928038
		fi

		CHOST_amd64=x86_64-w64-mingw32
		CHOST_x86=i686-w64-mingw32
		CHOST=$(usex arm64 aarch64-w64-mingw32 $(usex x86 ${CHOST_x86} ${CHOST_amd64}))
	fi

	winedll_foreach_abi multilib_src_configure
}

multilib_src_configure() {
	# multilib's ${CHOST_amd64}-gcc -m32 is unusable with crossdev,
	# unset again so meson eclass will set ${CHOST}-gcc + others
	use crossdev-mingw && [[ ! -v MINGW_BYPASS ]] && unset AR CC CXX RC STRIP

	local -A abi_to_libdir=(
		[amd64]=x64
		[arm64]=x64
		[x86]=x32
	)

	local emesonargs=(
		--prefix="${EPREFIX}"/usr/lib/${PN}
		--{bin,lib}dir=${abi_to_libdir[$ABI]}
		--force-fallback-for=libdisplay-info # system's is ELF (unusable)
		$(meson_use {,enable_}d3d8)
		$(meson_use {,enable_}d3d9)
		$(meson_use {,enable_}d3d10)
		$(meson_use {,enable_}d3d11)
		$(meson_use {,enable_}dxgi)
		$(usev strip --strip) # portage won't strip .dll, so allow it here
	)

	(
		strip-unsupported-flags
		meson_src_configure
	)
}

src_compile() {
	winedll_foreach_abi meson_src_compile
}

src_install() {
	winedll_foreach_abi meson_install

	dobin setup_dxvk.sh
	dodoc README.md dxvk.conf

	find "${ED}" -type f -name '*.a' -delete || die
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To enable ${PN} on a wine prefix, you can run the following command:"
		elog
		elog "	WINEPREFIX=/path/to/prefix setup_dxvk.sh install --symlink"
		elog
		elog "See ${EROOT}/usr/share/doc/${PF}/README.md* for details."
		elog "Note: setup_dxvk.sh is unofficially temporarily provided as it was"
		elog "removed upstream, handling may change in the future."
	fi

	if use d3d8 && ver_replacing -lt 2.4; then
		elog
		elog ">=${PN}-2.4 now provides d3d8.dll, to make use of it will need to"
		elog "update old wine prefixes which is typically done by re-running:"
		elog
		elog "	WINEPREFIX=/path/to/prefix setup_dxvk.sh install --symlink"
		elog
	fi
}
