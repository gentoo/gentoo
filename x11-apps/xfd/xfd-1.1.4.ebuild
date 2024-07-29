# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="X.Org xfd application"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXaw
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="sys-devel/gettext"
