# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org xset application"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXext"
DEPEND="${RDEPEND}"

XORG_CONFIGURE_OPTIONS=(
	--without-xf86misc
	--without-fontcache
)
