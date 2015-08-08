# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [ ${PV} = 9999* ]; then
	EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"
	inherit git-2
else
	SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit toolchain-funcs

DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui:a=summary"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

COMMON_DEPEND="x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	sys-apps/pmount
	virtual/udev"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc README.txt
}
