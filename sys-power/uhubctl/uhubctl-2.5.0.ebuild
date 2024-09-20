# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="USB hub per-port power control"
HOMEPAGE="https://github.com/mvp/uhubctl"
SRC_URI="https://github.com/mvp/uhubctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i \
		-e "s/^GIT_VERSION/#&/" \
		Makefile \
		|| die

	tc-export PKG_CONFIG
}

src_compile() {
	emake CC="$(tc-getCC)"
}
