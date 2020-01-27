# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Controls host and/or user access to a running X server"

KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="ipv6"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXau"
DEPEND="${RDEPEND}"

pkg_setup() {
	XORG_CONFIGURE_OPTIONS="$(use_enable ipv6)"
}
