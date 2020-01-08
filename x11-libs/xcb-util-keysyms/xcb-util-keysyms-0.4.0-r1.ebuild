# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MODULE=/
XORG_BASE_INDIVIDUAL_URI=https://xcb.freedesktop.org/dist
XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-2

EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms.git"

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="x11-libs/libxcb:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.1
	x11-base/xorg-proto
	test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_with doc doxygen)
	)
	xorg-2_src_configure
}
