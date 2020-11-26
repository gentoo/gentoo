# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A web monitor plugin for GKrellM2"
HOMEPAGE="http://gkwebmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc ~sparc x86"

# The Makefile links with -lssl.
RDEPEND="
	app-admin/gkrellm:2[X]
	dev-libs/openssl:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-cc-cflags-ldflags.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}
