# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxkbcommon/libxkbcommon-0.3.1.ebuild,v 1.5 2014/04/21 10:30:31 ago Exp $

EAPI=5
XORG_EAUTORECONF="yes"

if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
	EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}"
	KEYWORDS=""
else
	XORG_BASE_INDIVIDUAL_URI=""
	SRC_URI="http://xkbcommon.org/download/${P}.tar.xz"
	KEYWORDS="amd64 arm x86"
fi

inherit xorg-2 ${GIT_ECLASS}

DESCRIPTION="X.Org xkbcommon library"

IUSE="doc"

DEPEND="sys-devel/bison
	sys-devel/flex
	x11-proto/xproto
	>=x11-proto/kbproto-1.0.5
	doc? ( app-doc/doxygen )"
RDEPEND=""

XORG_CONFIGURE_OPTIONS=(
	--with-xkb-config-root="${EPREFIX}/usr/share/X11/xkb" $(use_with doc doxygen)
)
