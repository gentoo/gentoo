# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="Nice analog clock for GKrellM2"
HOMEPAGE="http://www.gkrellm.net/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="app-admin/gkrellm[X]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )

S="${WORKDIR}/${P/a/A}"

src_compile() {
	# The tarball contains a pre-compiled x86 object that needs to be
	# removed if we're going to build it properly. See bug 166133.
	rm -f gkrellaclock.o || die 'failed to remove gkrellaclock.o'
	emake CC="$(tc-getCC)"
}
