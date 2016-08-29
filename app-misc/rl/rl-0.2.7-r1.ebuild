# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-minimal

DESCRIPTION="Randomize lines from text files or stdin"
HOMEPAGE="https://arthurdejong.org/rl"
SRC_URI="https://arthurdejong.org/rl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~mips ~ppc ~s390 ~sparc ~x86"
IUSE="debug"

multilib_src_configure() {
	local myeconfargs=()
	use debug && myeconfargs+=(--enable-debug)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO
}
