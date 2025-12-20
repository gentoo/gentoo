# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit toolchain-funcs xorg-3

DESCRIPTION="C preprocessor interface to the make utility"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="x11-misc/xorg-cf-files"
DEPEND="x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.8-cpp-args.patch
	"${FILESDIR}"/${PN}-1.0.9-no-get-gcc.patch
	"${FILESDIR}"/${PN}-1.0.8-respect-LD.patch
	"${FILESDIR}"/${PN}-1.0.8-xmkmf-pass-cc-ld.patch
)

src_configure() {
	econf CPP="$(tc-getPROG CPP cpp)" #722046
}
