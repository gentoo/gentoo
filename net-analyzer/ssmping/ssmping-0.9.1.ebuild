# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tool for testing multicast connectivity"
HOMEPAGE="http://www.venaas.no/multicast/ssmping/"
SRC_URI="http://www.venaas.no/multicast/ssmping/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9-build.patch
)

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin ssmping asmping mcfirst
	dosbin ssmpingd
	doman ssmping.1 asmping.1 mcfirst.1
}
