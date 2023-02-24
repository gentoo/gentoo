# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SSH wrapper enabling zmodem up/download in ssh"
HOMEPAGE="https://zssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="nls readline"

DEPEND="readline? (
		sys-libs/ncurses:0
		sys-libs/readline:0
	)"
RDEPEND="${DEPEND}
	net-misc/openssh
	net-dialup/lrzsz"

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.5a-gentoo-include.diff"

	# Fix linking with sys-libs/ncurses[tinfo], bug #527036
	sed -i -e 's/-ltermcap/-ltinfo/g' configure || die

	eapply_user
}

src_configure() {
	tc-export AR CC RANLIB
	econf \
		$(use_enable nls) \
		$(use_enable readline)
}

src_install() {
	dobin ${PN} ztelnet
	doman ${PN}.1 ztelnet.1
	dodoc CHANGES FAQ README TODO
}
