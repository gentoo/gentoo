# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxkbcommon/libxkbcommon-0.4.1.ebuild,v 1.2 2014/06/18 21:07:59 mgorny Exp $

EAPI=5
XORG_EAUTORECONF="yes"
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
KEYWORDS="~amd64 ~arm ~x86"
IUSE="X doc"

DEPEND="sys-devel/bison
	sys-devel/flex
	X? ( >=x11-libs/libxcb-1.10[${MULTILIB_USEDEP},xkb] )
	>=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
	>=x11-proto/kbproto-1.0.6-r1[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )"
RDEPEND=""

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		--with-xkb-config-root="${EPREFIX}/usr/share/X11/xkb"
		$(use X || use_enable X x11)
		$(use_with doc doxygen)
	)
	xorg-2_pkg_setup
}
