# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/pixman/pixman.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson multilib-minimal multiprocessing toolchain-funcs

DESCRIPTION="Low-level pixel manipulation routines"
HOMEPAGE="http://www.pixman.org/ https://gitlab.freedesktop.org/pixman/pixman/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
	SRC_URI="https://www.x.org/releases/individual/lib/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_ppc_altivec cpu_flags_arm_iwmmxt cpu_flags_arm_iwmmxt2 cpu_flags_arm_neon loongson2f cpu_flags_x86_mmxext cpu_flags_x86_sse2 cpu_flags_x86_ssse3"

multilib_src_configure() {
	local openmp=disabled
	tc-has-openmp && openmp=enabled

	local emesonargs=(
		$(meson_feature cpu_flags_arm_iwmmxt iwmmxt)
		$(meson_use     cpu_flags_arm_iwmmxt2 iwmmxt2)
		$(meson_feature cpu_flags_x86_mmxext mmx)
		$(meson_feature cpu_flags_x86_sse2 sse2)
		$(meson_feature cpu_flags_x86_ssse3 ssse3)
		$(meson_feature cpu_flags_ppc_altivec vmx)
		$(meson_feature cpu_flags_arm_neon neon)
		$(meson_feature loongson2f loongson-mmi)
		-Dgtk=disabled
		-Dlibpng=disabled
		-Dopenmp=$openmp # only used in unit tests
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	export OMP_NUM_THREADS=$(makeopts_jobs)
	meson test -v -C "${BUILD_DIR}" -t 100
}

multilib_src_install() {
	meson_src_install
}
