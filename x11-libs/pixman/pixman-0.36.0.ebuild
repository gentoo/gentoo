# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_MULTILIB=yes
inherit xorg-2

EGIT_REPO_URI="https://gitlab.freedesktop.org/pixman/pixman.git"
DESCRIPTION="Low-level pixel manipulation routines"

if [[ $PV != 9999* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
fi

IUSE="altivec loongson2f cpu_flags_arm_iwmmxt cpu_flags_x86_mmxext neon cpu_flags_x86_sse2 cpu_flags_x86_ssse3"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable cpu_flags_arm_iwmmxt arm-iwmmxt)
		$(use_enable cpu_flags_x86_mmxext mmx)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
		$(use_enable altivec vmx)
		$(use_enable neon arm-neon)
		$(use_enable loongson2f loongson-mmi)
		--disable-gtk
		--disable-libpng
	)
	xorg-2_src_configure
}
