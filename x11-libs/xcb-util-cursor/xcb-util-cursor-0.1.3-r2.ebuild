# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MODULE=/
XORG_BASE_INDIVIDUAL_URI=https://xcb.freedesktop.org/dist
XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-2

EGIT_REPO_URI="https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor.git"
EGIT_HAS_SUBMODULES=yes

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/ https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=x11-libs/libxcb-1.9.1[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-image-0.3.9-r1[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-renderutil-0.3.9[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=x11-base/xcb-proto-1.8-r3:=[${MULTILIB_USEDEP}]
	x11-base/xorg-proto
	>=dev-util/gperf-3.0.1
	test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_with doc doxygen)
		--with-cursorpath='~/.cursors:~/.icons:/usr/local/share/cursors/xorg-x11:/usr/local/share/cursors:/usr/local/share/icons:/usr/local/share/pixmaps:/usr/share/cursors/xorg-x11:/usr/share/cursors:/usr/share/pixmaps/xorg-x11:/usr/share/icons:/usr/share/pixmaps'
	)

	xorg-2_src_configure
}
