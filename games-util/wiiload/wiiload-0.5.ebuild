# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-util/wiiload/wiiload-0.5.ebuild,v 1.4 2015/02/19 09:07:47 mr_bones_ Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="load homebrew apps over the network to your Wii"
HOMEPAGE="http://wiibrew.org/wiki/Wiiload"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LFLAGS="${LDFLAGS}" || die
}

src_install() {
	dobin wiiload
}
