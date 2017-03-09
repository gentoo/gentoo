# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_MULTILIB="yes"

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
	EGIT_REPO_URI="git://github.com/xkbcommon/${PN}"
else
	XORG_BASE_INDIVIDUAL_URI=""
	SRC_URI="http://xkbcommon.org/download/${P}.tar.xz"
fi

inherit xorg-2 ${GIT_ECLASS}

DESCRIPTION="X.Org xkbcommon library"
HOMEPAGE="https://xkbcommon.org/"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="X doc test"

DEPEND="sys-devel/bison
	X? (
		>=x11-libs/libxcb-1.10[${MULTILIB_USEDEP},xkb]
		>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
		>=x11-proto/kbproto-1.0.6-r1[${MULTILIB_USEDEP}]
	)
	doc? ( app-doc/doxygen )"
RDEPEND="X? ( >=x11-libs/libxcb-1.10[${MULTILIB_USEDEP},xkb] )"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--with-xkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		$(use X || use_enable X x11)
		$(use_with doc doxygen)
	)
	xorg-2_pkg_setup
}
