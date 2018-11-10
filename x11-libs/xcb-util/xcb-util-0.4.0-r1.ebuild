# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_MODULE=/
XORG_BASE_INDIVIDUAL_URI=https://xcb.freedesktop.org/dist
XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-2

EGIT_REPO_URI="https://anongit.freedesktop.org/git/xcb/util.git"

DESCRIPTION="X C-language Bindings sample implementations"
HOMEPAGE="https://xcb.freedesktop.org/"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE="test"

RDEPEND=">=x11-libs/libxcb-1.9.1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	>=dev-util/gperf-3.0.1
	test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"

PDEPEND="
	>=x11-libs/xcb-util-cursor-0.1.1:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-image-${PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-keysyms-${PV}:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-renderutil-0.3.9:=[${MULTILIB_USEDEP}]
	>=x11-libs/xcb-util-wm-${PV}:=[${MULTILIB_USEDEP}]
"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_with doc doxygen)
	)
	xorg-2_src_configure
}
