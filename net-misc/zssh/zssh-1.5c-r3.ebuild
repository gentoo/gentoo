# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs autotools

DESCRIPTION="SSH wrapper enabling zmodem up/download in ssh"
HOMEPAGE="https://zssh.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls readline"

DEPEND="
	readline? (
		sys-libs/ncurses:=
		sys-libs/readline:=
	)
"
RDEPEND="
	${DEPEND}
	net-dialup/lrzsz[nls?]
	virtual/openssh
"

PATCHES=(
	"${FILESDIR}/${PN}-1.5a-gentoo-include.diff"
	"${FILESDIR}/${P}-C23.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	tc-export AR CC RANLIB
	econf \
		$(use_enable readline)
}

src_install() {
	dobin ${PN} ztelnet
	doman ${PN}.1 ztelnet.1
	dodoc CHANGES FAQ README TODO
}
