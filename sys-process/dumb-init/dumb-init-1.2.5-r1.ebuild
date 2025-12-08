# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A minimal init system for Linux containers"
HOMEPAGE="https://github.com/Yelp/dumb-init"
SRC_URI="https://github.com/Yelp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.5-flags.patch
)

src_prepare() {
	default
	use static && append-cflags -static
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
