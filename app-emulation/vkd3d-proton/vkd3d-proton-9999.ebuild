# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_ABIS="amd64 x86" # allow usage on /no-multilib/
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit flag-o-matic meson-multilib toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HansKristian-Work/vkd3d-proton.git"
	EGIT_SUBMODULES=(
		# uses hacks / recent features and easily breaks, keep bundled headers
		# (also cross-compiled and -I/usr/include is troublesome)
		subprojects/{SPIRV,Vulkan}-Headers
		subprojects/dxil-spirv
		subprojects/dxil-spirv/third_party/spirv-headers # skip cross/tools
	)
else
	HASH_VKD3D=6365efeba253807beecaed0eaa963295522c6b70 # match tag on bumps
	HASH_DXIL=f20a0fb4e984a83743baa9d863eb7b26228bcca3
	HASH_SPIRV=1d31a100405cf8783ca7a31e31cdd727c9fc54c3
	HASH_SPIRV_DXIL=aa331ab0ffcb3a67021caa1a0c1c9017712f2f31
	HASH_VULKAN=bd6443d28f2ebecedfb839b52d612011ba623d14
	SRC_URI="
		https://github.com/HansKristian-Work/vkd3d-proton/archive/refs/tags/v${PV}.tar.gz
			-> ${P}.tar.gz
		https://github.com/HansKristian-Work/dxil-spirv/archive/${HASH_DXIL}.tar.gz
			-> ${PN}-dxil-spirv-${HASH_DXIL::10}.tar.gz
		https://github.com/KhronosGroup/SPIRV-Headers/archive/${HASH_SPIRV}.tar.gz
			-> ${PN}-spirv-headers-${HASH_SPIRV::10}.tar.gz
		https://github.com/KhronosGroup/SPIRV-Headers/archive/${HASH_SPIRV_DXIL}.tar.gz
			-> ${PN}-spirv-headers-${HASH_SPIRV_DXIL::10}.tar.gz
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${HASH_VULKAN}.tar.gz
			-> ${PN}-vulkan-headers-${HASH_VULKAN::10}.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi

DESCRIPTION="Fork of VKD3D, development branches for Proton's Direct3D 12 implementation"
HOMEPAGE="https://github.com/HansKristian-Work/vkd3d-proton/"

LICENSE="LGPL-2.1+ Apache-2.0 MIT"
SLOT="0"
IUSE="+abi_x86_32 crossdev-mingw debug extras +strip"

BDEPEND="
	dev-util/glslang
	!crossdev-mingw? ( dev-util/mingw64-toolchain[${MULTILIB_USEDEP}] )"

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
				die "USE=crossdev-mingw is enabled, but ${tool} was not found"
			elif [[ ! $(LC_ALL=C ${tool} -v 2>&1) =~ "Thread model: posix" ]]; then
				eerror "${PN} requires GCC to be built with --enable-threads=posix"
				eerror "Please see: https://wiki.gentoo.org/wiki/Mingw#POSIX_threads_for_Windows"
				die "USE=crossdev-mingw is enabled, but ${tool} does not use POSIX threads"
			fi
		done
		tool=-w64-mingw32-widl
		for tool in $(usev abi_x86_64 x86_64${tool}) $(usev abi_x86_32 i686${tool}); do
			if ! type -P widl >/dev/null && ! type -P ${tool} >/dev/null; then
				eerror "With USE=crossdev-mingw, you need to provide the widl compiler by either"
				eerror "building crossdev mingw64-runtime with USE=tools or installing wine."
				die "USE=crossdev-mingw is set but neither widl nor ${tool} were found"
			fi
		done
	fi
}

src_prepare() {
	if [[ ${PV} != 9999 ]]; then
		rmdir subprojects/{{SPIRV,Vulkan}-Headers,dxil-spirv} || die
		mv ../dxil-spirv-${HASH_DXIL} subprojects/dxil-spirv || die
		mv ../SPIRV-Headers-${HASH_SPIRV} subprojects/SPIRV-Headers || die
		mv ../Vulkan-Headers-${HASH_VULKAN} subprojects/Vulkan-Headers || die

		# dxil and vkd3d's spirv headers currently mismatch and incompatible
		rmdir subprojects/dxil-spirv/third_party/spirv-headers || die
		mv ../SPIRV-Headers-${HASH_SPIRV_DXIL} \
			subprojects/dxil-spirv/third_party/spirv-headers || die
#		ln -s ../../../SPIRV-Headers/include \
#			subprojects/dxil-spirv/third_party/spirv-headers || die
	fi

	default

	sed -i "/^basedir=/s|=.*|=${EPREFIX}/usr/lib/${PN}|" setup_vkd3d_proton.sh || die

	if [[ ${PV} != 9999 ]]; then
		# without .git, meson sets vkd3d_build as 0x${PV} leading to failure
		sed -i "s/@VCS_TAG@/${HASH_VKD3D::15}/" vkd3d_build.h.in || die
		sed -i "s/@VCS_TAG@/${HASH_VKD3D::7}/" vkd3d_version.h.in || die
	fi
}

src_configure() {
	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	# -mavx with mingw-gcc has a history of obscure issues and
	# disabling is seen as safer, e.g. `WINEARCH=win32 winecfg`
	# crashes with -march=skylake >=wine-8.10, similar issues with
	# znver4: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110273
	append-flags -mno-avx

	if [[ ${CHOST} != *-mingw* ]]; then
		if [[ ! -v MINGW_BYPASS ]]; then
			unset AR CC CXX RC STRIP WIDL
			filter-flags '-fuse-ld=*'
			filter-flags '-mfunction-return=thunk*' #878849
			if has_version '<dev-util/mingw64-toolchain-11' ||
				{ use crossdev-mingw &&
					has_version "<cross-$(usex x86 i686 x86_64)-w64-mingw32/mingw64-runtime-11"; }
			then
				filter-flags '-fstack-protector*' #870136
			fi
		fi

		CHOST_amd64=x86_64-w64-mingw32
		CHOST_x86=i686-w64-mingw32
		CHOST=$(usex x86 ${CHOST_x86} ${CHOST_amd64})

		# preferring meson eclass' cross file over upstream's but, unlike
		# dxvk, we lose static options in the process (from build-win*.txt)
		append-ldflags -static -static-libgcc -static-libstdc++

		strip-unsupported-flags
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	# multilib's ${CHOST_amd64}-gcc -m32 is unusable with crossdev,
	# unset again so meson eclass will set ${CHOST}-gcc + others
	use crossdev-mingw && [[ ! -v MINGW_BYPASS ]] && unset AR CC CXX STRIP WIDL

	# prefer ${CHOST}'s widl (mingw) over wine's as used by upstream if
	# possible, but eclasses don't handle that so setup machine files
	local widl=$(tc-getPROG WIDL widl)
	use amd64 && [[ ${widl} == widl && ${ABI} == x86 ]] && widl="widl','-m32"
	printf "[binaries]\nwidl = ['${widl}']\n" > "${T}"/widl.${ABI}.ini || die

	local emesonargs=(
		--prefix="${EPREFIX}"/usr/lib/${PN}
		--{bin,lib}dir=x${ABI: -2}
		--{cross,native}-file="${T}"/widl.${ABI}.ini
		$(meson_use {,enable_}extras)
		$(meson_use debug enable_trace)
		$(usev strip --strip) # portage won't strip .dll, so allow it here
		-Denable_tests=false # needs wine/vulkan and is intended for manual use
	)

	meson_src_configure
}

multilib_src_install_all() {
	dobin setup_vkd3d_proton.sh
	einstalldocs

	find "${ED}" -type f -name '*.a' -delete || die
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To enable ${PN} on a wine prefix, you can run the following command:"
		elog
		elog "	WINEPREFIX=/path/to/prefix setup_vkd3d_proton.sh install --symlink"
		elog
		elog "Should also ensure that >=app-emulation/dxvk-2.1's dxgi.dll is available"
		elog "on it, not meant to function independently even if only using d3d12."
		elog
		elog "See ${EROOT}/usr/share/doc/${PF}/README.md* for details."
	elif [[ ${REPLACING_VERSIONS##* } ]]; then
		if ver_test ${REPLACING_VERSIONS##* } -lt 2.7; then
			elog
			elog ">=${PN}-2.7 requires drivers and Wine to support vulkan-1.3, meaning:"
			elog ">=wine-*-7.1 (or >=wine-proton-7.0), and >=mesa-22.0 (or >=nvidia-drivers-510)"
		fi

		if ver_test ${REPLACING_VERSIONS##* } -lt 2.9; then
			elog
			elog ">=${PN}-2.9 has a new file to install (d3d12core.dll), old Wine prefixes that"
			elog "relied on '--symlink' may need updates by using the setup_vkd3d_proton.sh."
			elog
			elog "Furthermore, it may not function properly if >=app-emulation/dxvk-2.1's"
			elog "dxgi.dll is not available on that prefix (even if only using d3d12)."
		fi
	fi
}
