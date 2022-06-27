# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shim header for net/ppp_defs.h on musl"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Musl"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~riscv x86"

RDEPEND="!sys-libs/glibc"

S=${WORKDIR}

src_install() {
	insinto /usr/include/net
	doins "${FILESDIR}/ppp_defs.h"
}
