# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="The Ogg media file format library"
HOMEPAGE="https://xiph.org/ogg/"
SRC_URI="https://downloads.xiph.org/releases/ogg/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.4-libdir-m4.patch
	"${FILESDIR}"/${PN}-1.3.5-macro-wstrict-prototypes.patch
	"${FILESDIR}"/${P}-ubsan-shift.patch
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ogg/config_types.h
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name "*.la" -delete || die
}
