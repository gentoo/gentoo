# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEPEND="
	x11-libs/libfontenc
	media-libs/freetype:2
	sys-libs/zlib
	app-arch/bzip2"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto"
RDEPEND="${COMMON_DEPEND}
	!<x11-apps/mkfontdir-1.2.0"

XORG_CONFIGURE_OPTIONS=(
	--with-bzip2
)
