# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="create an index of scalable font files for X"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	x11-libs/libfontenc
	media-libs/freetype:2
	virtual/zlib:=
	app-arch/bzip2"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

XORG_CONFIGURE_OPTIONS=(
	--with-bzip2
)
