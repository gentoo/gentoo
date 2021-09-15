# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Command-line utility for filesystem quotas"
HOMEPAGE="http://quotatool.ekenberg.se/"
SRC_URI="http://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

RDEPEND="sys-fs/quota"

PATCHES=( "${FILESDIR}"/${PN}-1.4.13-fix-buildsystem.patch )

src_configure() {
	tc-export CC
	default
}

src_install() {
	dodir /usr/sbin /usr/share/man/man8
	default
}
