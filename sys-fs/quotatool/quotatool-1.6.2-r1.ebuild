# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Command-line utility for filesystem quotas"
HOMEPAGE="https://quotatool.ekenberg.se/"
SRC_URI="https://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

RDEPEND="sys-fs/quota"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.13-fix-buildsystem.patch
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-fix-autoconf.patch
	"${FILESDIR}"/${P}-warnings.patch
)

src_configure() {
	tc-export CC
	default
}

src_install() {
	# TODO: drop on next release (https://github.com/ekenberg/quotatool/commit/5529c8084a06d4d95905f76e47d2621564876081)
	dodir /usr/sbin /usr/share/man/man8
	default
}
