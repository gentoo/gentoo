# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

DESCRIPTION="libnss-cache is a library that serves nss lookups"
HOMEPAGE="https://github.com/google/nsscache"
SRC_URI="https://nsscache.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT=test # needs special sudo configuration, bug #422567

PATCHES=(
	"${FILESDIR}"/${PN}-0.10.1-make.patch
	"${FILESDIR}"/${PN}-0.10-fix-shadow-test.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" nss_cache
}

multilib_src_install() {
	emake DESTDIR="${ED}" LIBDIR="${ED}/usr/$(get_libdir)" install
}
