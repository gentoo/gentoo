# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Comprehensive filesystem mirroring program"
HOMEPAGE="https://apollo.backplane.com/FreeSrc/"
SRC_URI="https://apollo.backplane.com/FreeSrc/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/libbsd:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-portable.patch
)

src_prepare() {
	default
	rm compat_linux.c || die
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin cpdup
	doman cpdup.1
	dodoc -r scripts
}
