# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
	VKD3D_HASH=3e5aab6fb3e18f81a71b339be4cb5cdf55140980 # match tag on bumps
	DXIL_HASH=b537bbb91bccdbc695cb7e5211d608f8d1c205bd
	SPIRV_HASH=ae217c17809fadb232ec94b29304b4afcd417bb4
	VULKAN_HASH=83e1a9ed8ce289cebb1c02c8167d663dc1befb24
	SRC_URI="
		https://github.com/HansKristian-Work/vkd3d-proton/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/HansKristian-Work/dxil-spirv/archive/${DXIL_HASH}.tar.gz -> ${P}-dxil-spirv.tar.gz
		https://github.com/KhronosGroup/SPIRV-Headers/archive/${SPIRV_HASH}.tar.gz -> ${P}-vulkan-headers.tar.gz
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${VULKAN_HASH}.tar.gz -> ${P}-spirv-headers.tar.gz"
	KEYWORDS="-* ~amd64 ~x86"
fi

DESCRIPTION="Fork of VKD3D, development branches for Proton's Direct3D 12 implementation"
HOMEPAGE="https://github.com/HansKristian-Work/vkd3d-proton/"

LICENSE="LGPL-2.1+ Apache-2.0 MIT"
SLOT="0"
IUSE="+abi_x86_32 crossdev-mingw debug extras"

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
				die "USE=crossdev-mingw is set but ${tool} was not found"
			elif [[ ! $(LC_ALL=C ${tool} -v 2>&1) =~ "Thread model: posix" ]]; then
				eerror "${PN} requires GCC to be built with --enable-threads=posix"
				eerror "Please see: https://wiki.gentoo.org/wiki/Mingw#POSIX_threads_for_Windows"
				die "USE=crossdev-mingw is set but ${tool} does not use POSIX threads"
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
		mv ../dxil-spirv-${DXIL_HASH} subprojects/dxil-spirv || die
		mv ../SPIRV-Headers-${SPIRV_HASH} subprojects/SPIRV-Headers || die
		mv ../Vulkan-Headers-${VULKAN_HASH} subprojects/Vulkan-Headers || die
		ln -s ../../../SPIRV-Headers/include \
			subprojects/dxil-spirv/third_party/spirv-headers || die
	fi

	default

	sed -i "/^basedir=/s|=.*|=${EPREFIX}/usr/lib/${PN}|" setup_vkd3d_proton.sh || die

	if [[ ${PV} != 9999 ]]; then
		# without .git, meson sets vkd3d_build as 0x${PV} leading to failure
		sed -i "s/@VCS_TAG@/${VKD3D_HASH::15}/" vkd3d_build.h.in || die
		sed -i "s/@VCS_TAG@/${VKD3D_HASH::7}/" vkd3d_version.h.in || die
	fi
}

src_configure() {
	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	if [[ ${CHOST} != *-mingw* ]]; then
		if [[ ! -v MINGW_BYPASS ]]; then
			unset AR CC CXX RC STRIP WIDL
			filter-flags '-fstack-protector*' #870136
			filter-flags '-fuse-ld=*'
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
		$(usev !debug --strip) # portage won't strip .dll, so allow it here
		-Denable_tests=false # needs wine/vulkan and is intended for manual use
	)

	meson_src_configure
}

multilib_src_install_all() {
	dobin setup_vkd3d_proton.sh
	einstalldocs

	# unnecesasry files, see package-release.sh
	rm "${ED}"/usr/lib/${PN}/x*/libvkd3d-proton-utils-3.dll || die
	find "${ED}" -type f -name '*.a' -delete || die
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "To enable ${PN} on a wine prefix, you can run the following command:"
		elog
		elog "	WINEPREFIX=/path/to/prefix setup_vkd3d_proton.sh install --symlink"
		elog
		elog "See ${EROOT}/usr/share/doc/${PF}/README.md* for details."
	fi

	# don't try to keep wine-*[vulkan] in RDEPEND, but still give a warning
	local wine
	for wine in app-emulation/wine-{vanilla,staging}; do
		has_version ${wine} && ! has_version ${wine}[vulkan] &&
			ewarn "${wine} was not built with USE=vulkan, ${PN} will not be usable with it"
	done
}
