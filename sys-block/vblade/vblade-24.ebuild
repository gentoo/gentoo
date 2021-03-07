# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="vblade exports a block device using AoE"
HOMEPAGE="https://github.com/OpenAoE/vblade"
SRC_URI="https://github.com/OpenAoE/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="sys-apps/util-linux"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	dosbin vblade
	dosbin "${FILESDIR}"/vbladed

	doman vblade.8
	dodoc HACKING NEWS README

	newconfd "${FILESDIR}"/conf.d-vblade vblade
	newinitd "${FILESDIR}"/init.d-vblade.vblade0-r2 vblade.vblade0
}
