# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="git://git.tdb.fi/pmount-gui"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~ssuominen/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit toolchain-funcs

DESCRIPTION="A simple graphical frontend for pmount"
HOMEPAGE="http://git.tdb.fi/?p=pmount-gui.git;a=summary"

LICENSE="BSD-2"
SLOT="0"

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	sys-apps/pmount
	virtual/udev"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc README.txt
}
