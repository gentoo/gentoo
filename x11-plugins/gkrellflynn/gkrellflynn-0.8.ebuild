# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

HOMEPAGE="http://bax.comlab.uni-rostock.de/en/projects/flynn.html"
SRC_URI="http://bax.comlab.uni-rostock.de/fileadmin/downloads/${P}.tar.gz"
DESCRIPTION="A funny GKrellM2 load monitor (for Doom(tm) fans)"

KEYWORDS="alpha amd64 ppc sparc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" gkrellm2
}
