# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm toolchain-funcs

DESCRIPTION="A library for emulating x86"
HOMEPAGE="https://www.opensuse.org/"
SRC_URI="https://download.opensuse.org/source/factory/repo/oss/suse/src/${P}-9.8.src.rpm"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1-fix-makefile.patch
	"${FILESDIR}"/${PN}-1.1-gcc10-fno-common.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	dodoc Changelog README
}
