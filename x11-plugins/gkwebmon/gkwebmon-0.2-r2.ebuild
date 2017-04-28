# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A web monitor plugin for GKrellM2"
HOMEPAGE="http://${PN}.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc x86"
IUSE=""

# The Makefile links with -lssl.
COMMON_DEPEND="app-admin/gkrellm[X]
	dev-libs/openssl:0"

DEPEND+=" ${COMMON_DEPEND}"
RDEPEND+=" ${COMMON_DEPEND}"

PATCHES=( "${FILESDIR}/respect-cc-cflags-ldflags.patch" )

src_compile() {
	emake CC="$(tc-getCC)"
}
