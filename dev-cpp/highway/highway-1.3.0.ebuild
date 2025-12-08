# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs

DESCRIPTION="Performance-portable, length-agnostic SIMD with runtime dispatch"
HOMEPAGE="https://github.com/google/highway"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/highway.git"
else
	SRC_URI="https://github.com/google/highway/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="cpu_flags_arm_neon test"

DEPEND="test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )"
BDEPEND="|| ( >=sys-devel/binutils-2.44:* llvm-core/lld sys-devel/native-cctools )"

RESTRICT="!test? ( test )"

check_binutils_version() {
	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] && ! tc-ld-is-gold && ! tc-ld-is-lld ; then
		# Okay, hopefully it's Binutils, but we don't have a nice way of checking
		# the gas version.
		#
		# Convert this:
		# ```
		# GNU assembler (Gentoo 2.44 p1) 2.44
		# Copyright (C) 2022 Free Software Foundation, Inc.
		# This program is free software; you may redistribute it under the terms of
		# the GNU General Public License version 3 or (at your option) a later version.
		# This program has absolutely no warranty.
		# ```
		#
		# into...
		# ```
		# 2.44
		# ```
		local ver=$($(tc-getAS) --version 2>&1 | head -n 1 | rev | cut -d' ' -f1 | rev)

		if ! [[ ${ver} =~ [0-9].[0-9][0-9] ]] ; then
			# Skip if unrecognised format so we don't pass something
			# odd into ver_cut.
			return
		fi

		ver_major=$(ver_cut 1 "${ver}")
		ver_minor=$(ver_cut 2 "${ver}")

		# Check borrowed from sys-apps/pciutils (see bug #966644).
		if [[ ${ver_major} -eq 2 && ${ver_minor} -lt 44 ]] ; then
			eerror "Old version of binutils activated! ${P} cannot be built with an old version."
			eerror "Please follow these steps:"
			eerror "1. Select a newer binutils (>= 2.44) using binutils-config"
			eerror " (If no such version is installed, run emerge -v1 sys-devel/binutils)"
			eerror "2. Run: . /etc/profile"
			eerror "3. Try emerging again with: emerge -v1 ${CATEGORY}/${P}"
			eerror "4. Complete your world upgrade if you were performing one."
			eerror "5. Perform a depclean (emerge -acv)"
			eerror "\tYou MUST depclean after every world upgrade in future!"
			die "Old binutils found! Change to a newer (g)as using binutils-config."
		fi
	fi
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && check_binutils_version
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && check_binutils_version
}

multilib_src_configure() {
	local mycmakeargs=(
		-DHWY_CMAKE_ARM7=$(usex cpu_flags_arm_neon)
		-DBUILD_TESTING=$(usex test)
		-DHWY_ENABLE_TESTS=$(usex test)
		-DHWY_WARNINGS_ARE_ERRORS=OFF
	)

	use test && mycmakeargs+=( "-DHWY_SYSTEM_GTEST=ON" )

	cmake_src_configure
}
