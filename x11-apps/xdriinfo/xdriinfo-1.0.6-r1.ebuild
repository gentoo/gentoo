# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3 flag-o-matic

DESCRIPTION="query configuration information of DRI drivers"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	x11-libs/libX11
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_setup() {
	xorg-3_pkg_setup

	append-cppflags "-I${EPREFIX}/usr/$(get_libdir)/opengl/xorg-x11/include/"
}
