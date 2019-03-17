# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://gitlab.freedesktop.org/pixman/pixman.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS} meson multilib-minimal

DESCRIPTION="Low-level pixel manipulation routines"
HOMEPAGE="http://www.pixman.org/ https://gitlab.freedesktop.org/pixman/pixman/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
	SRC_URI="https://www.x.org/releases/individual/lib/${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
IUSE="altivec cpu_flags_arm_iwmmxt loongson2f cpu_flags_x86_mmxext neon cpu_flags_x86_sse2 cpu_flags_x86_ssse3"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-r3_src_unpack
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature cpu_flags_arm_iwmmxt iwmmxt)
		$(meson_feature cpu_flags_x86_mmxext mmx)
		$(meson_feature cpu_flags_x86_sse2 sse2)
		$(meson_feature cpu_flags_x86_ssse3 ssse3)
		$(meson_feature altivec vmx)
		$(meson_feature neon neon)
		$(meson_feature loongson2f loongson-mmi)
		-Dgtk=disabled
		-Dlibpng=disabled
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
