# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A web monitor plugin for GKrellM2"
HOMEPAGE="http://gkwebmon.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc ~sparc x86"
IUSE=""

# The Makefile links with -lssl.
RDEPEND="
	app-admin/gkrellm:2[X]
	dev-libs/openssl:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/respect-cc-cflags-ldflags.patch )

src_compile() {
	emake CC="$(tc-getCC)"
}
