# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_STATIC=no
inherit toolchain-funcs xorg-3

DESCRIPTION="C preprocessor interface to the make utility"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-misc/xorg-cf-files"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_configure() {
	econf CPP="$(tc-getPROG CPP cpp)"
}
