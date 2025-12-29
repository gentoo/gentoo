# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_ABIS="amd64 x86" # allow usage on /no-multilib/
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit eapi9-ver flag-o-matic meson-multilib toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HansKristian-Work/vkd3d-proton.git"
else
	# tarball is same as upstream except for including git submodules
	SRC_URI="https://dev.gentoo.org/~ionen/distfiles/${P}.tar.xz"
	KEYWORDS="-* amd64 x86"
fi

DESCRIPTION="Fork of VKD3D, development branches for Proton's Direct3D 12 implementation"
HOMEPAGE="https://github.com/HansKristian-Work/vkd3d-proton/"

LICENSE="LGPL-2.1+ Apache-2.0 MIT"
SLOT="0"
IUSE="+abi_x86_32 crossdev-mingw debug extras +strip"

BDEPEND="
	dev-util/glslang
	!crossdev-mingw? ( dev-util/mingw64-toolchain[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-2.6-wow64-setup.patch
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
	default

	sed -i "/^basedir=/s|=.*|=${EPREFIX}/usr/lib/${PN}|" setup_vkd3d_proton.sh || die

	if [[ ${PV} != 9999 ]]; then
		# update to match version+hash of release tag on bump
		local tag_ver=3.0b
		local tag_hash=21a49c975df83a7c5e7c0a68b5c1fb58f23df7c1
		[[ ${PV} == ${tag_ver} ]] || die "hash has not been updated"

		# without .git, meson sets vkd3d_build as 0x${PV} leading to failure
		sed -i "s/@VCS_TAG@/${tag_hash::15}/" vkd3d_build.h.in || die
		sed -i "s/@VCS_TAG@/${tag_hash::7}/" vkd3d_version.h.in || die
	fi
}

src_configure() {
	use crossdev-mingw || PATH=${BROOT}/usr/lib/mingw64-toolchain/bin:${PATH}

	# random segfaults been reported with LTO in some games, filter as
	# a safety (note that optimizing this further won't really help
	# performance, GPU does the actual work)
	filter-lto

	# -mavx and mingw-gcc do not mix safely here
	# https://github.com/doitsujin/dxvk/issues/4746#issuecomment-2708869202
	append-flags -mno-avx

	if [[ ${CHOST} != *-mingw* ]]; then
		if [[ ! -v MINGW_BYPASS ]]; then
			unset AR CC CXX RC STRIP WIDL
			filter-flags '-fuse-ld=*'
			filter-flags '-mfunction-return=thunk*' #878849

			# some bashrc-mv users tend to do CFLAGS="${LDFLAGS}" and then
			# strip-unsupported-flags miss these during compile-only tests
			# (primarily done for 23.0 profiles' -z, not full coverage)
			filter-flags '-Wl,-z,*' #928038
		fi

		CHOST_amd64=x86_64-w64-mingw32
		CHOST_x86=i686-w64-mingw32
		CHOST=$(usex x86 ${CHOST_x86} ${CHOST_amd64})

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
	fi

	if ver_replacing -lt 2.7; then
		elog
		elog ">=${PN}-2.7 requires drivers and Wine to support vulkan-1.3, meaning:"
		elog ">=wine-*-7.1 (or >=wine-proton-7.0), and >=mesa-22.0 (or >=nvidia-drivers-510)"
	fi

	if ver_replacing -lt 2.9; then
		elog
		elog ">=${PN}-2.9 has a new file to install (d3d12core.dll), old Wine prefixes that"
		elog "relied on '--symlink' may need updates by using the setup_vkd3d_proton.sh."
		elog
		elog "Furthermore, it may not function properly if >=app-emulation/dxvk-2.1's"
		elog "dxgi.dll is not available on that prefix (even if only using d3d12)."
	fi
}
