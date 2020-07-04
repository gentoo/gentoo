# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="Nice analog clock for GKrellM2"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/a/A}"
PATCHES=( "${FILESDIR}"/${PN}-makefile.patch )

src_prepare() {
	default

	# The tarball contains a pre-compiled x86 object that needs to be
	# removed if we're going to build it properly. See bug 166133.
	rm -f gkrellaclock.o || die 'failed to remove gkrellaclock.o'
}

src_compile() {
	emake CC="$(tc-getCC)"
}
