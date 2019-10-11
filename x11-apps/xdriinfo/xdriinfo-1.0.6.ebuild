# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2 flag-o-matic multilib

DESCRIPTION="query configuration information of DRI drivers"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	virtual/opengl"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

pkg_setup() {
	xorg-2_pkg_setup

	append-cppflags "-I${EPREFIX}/usr/$(get_libdir)/opengl/xorg-x11/include/"
}
