# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="A simple countdown clock for GKrellM2"
SRC_URI="http://oss.pugsplace.net/${P}.tar.gz"
HOMEPAGE="http://freecode.com/projects/gkrellm-countdown"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
