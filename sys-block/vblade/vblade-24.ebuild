# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="vblade exports a block device using AoE"
HOMEPAGE="https://github.com/OpenAoE/vblade"
SRC_URI="https://github.com/OpenAoE/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="sys-apps/util-linux"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default

	sed -i -e 's,^CFLAGS.*,CFLAGS += -Wall,' \
		-e 's:-o vblade:${LDFLAGS} \0:' \
		makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dosbin vblade
	dosbin "${FILESDIR}"/vbladed
	doman vblade.8
	dodoc HACKING NEWS README
	newconfd "${FILESDIR}"/conf.d-vblade vblade
	newinitd "${FILESDIR}"/init.d-vblade.vblade0-r2 vblade.vblade0
}
