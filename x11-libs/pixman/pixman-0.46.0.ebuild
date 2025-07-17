# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://gitlab.freedesktop.org/pixman/pixman.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit flag-o-matic ${GIT_ECLASS} meson-multilib multiprocessing toolchain-funcs

DESCRIPTION="Low-level pixel manipulation routines"
HOMEPAGE="http://www.pixman.org/ https://gitlab.freedesktop.org/pixman/pixman/"
if [[ ${PV} != 9999* ]]; then
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
	SRC_URI="https://www.x.org/releases/individual/lib/${P}.tar.xz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_ppc_altivec cpu_flags_arm_neon loongson2f cpu_flags_x86_mmxext cpu_flags_x86_sse2 cpu_flags_x86_ssse3 static-libs test"
RESTRICT="!test? ( test )"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use test && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use test && tc-check-openmp
}

multilib_src_configure() {
	# Temporary workaround for a build failure (known gcc issue):
	#
	#  * https://bugs.gentoo.org/956715
	#  * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110812
	#
	use riscv && filter-lto

	local emesonargs=(
		$(meson_feature cpu_flags_x86_mmxext mmx)
		$(meson_feature cpu_flags_x86_sse2 sse2)
		$(meson_feature cpu_flags_x86_ssse3 ssse3)
		$(meson_feature cpu_flags_ppc_altivec vmx)
		$(meson_feature loongson2f loongson-mmi)
		$(meson_feature test openmp) # only used in unit tests
		$(meson_feature test tests)
		-Ddefault_library=$(usex static-libs both shared)
		-Ddemos=disabled
		-Dgtk=disabled
		-Dlibpng=disabled
	)

	if [[ ${ABI} == arm64 ]]; then
		emesonargs+=($(meson_feature cpu_flags_arm_neon a64-neon))
	elif [[ ${ABI} == arm ]]; then
		emesonargs+=($(meson_feature cpu_flags_arm_neon neon))
	fi

	meson_src_configure
}

multilib_src_test() {
	export OMP_NUM_THREADS=$(makeopts_jobs)
	meson_src_test -t 100
}
