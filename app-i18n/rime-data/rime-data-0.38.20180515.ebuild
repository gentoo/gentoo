# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="brise"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Data resources for Rime Input Method Engine"
HOMEPAGE="https://rime.im/ https://github.com/rime/brise"
SRC_URI="https://github.com/rime/${MY_PN}/releases/download/${MY_P%.*}/${MY_P}.tar.gz"

LICENSE="GPL-3 LGPL-3 extra? ( Apache-2.0 )"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="extra"

DEPEND="app-i18n/librime"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_PN}"

src_prepare() {
	sed -i "/^[[:space:]]*PREFIX/s:/usr:${EPREFIX}/usr:" Makefile

	default
}

src_compile() {
	emake $(usex extra all preset)
}
