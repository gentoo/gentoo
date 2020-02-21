# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

inherit eutils

DESCRIPTION="command-line utility for filesystem quotas"
HOMEPAGE="http://quotatool.ekenberg.se/"
SRC_URI="http://quotatool.ekenberg.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="sys-fs/quota"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.13-ldflags.patch
}

src_install () {
	dodir /usr/sbin /usr/share/man/man8
	default
}
