# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
XORG_MULTILIB="yes"

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
	EGIT_REPO_URI="https://github.com/xkbcommon/${PN}"
else
	XORG_BASE_INDIVIDUAL_URI=""
	SRC_URI="https://xkbcommon.org/download/${P}.tar.xz"
fi

inherit xorg-3 ${GIT_ECLASS}

DESCRIPTION="X.Org xkbcommon library"
HOMEPAGE="https://xkbcommon.org/"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="X doc test"

BDEPEND="
	sys-devel/bison
	doc? ( app-doc/doxygen )"
RDEPEND="X? ( >=x11-libs/libxcb-1.10:=[${MULTILIB_USEDEP},xkb] )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--with-xkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		$(use X || use_enable X x11)
		$(use_with doc doxygen)
	)
}
