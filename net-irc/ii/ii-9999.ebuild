# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fixheadtails git-r3 toolchain-funcs

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="http://tools.suckless.org/ii/"
EGIT_REPO_URI="http://git.suckless.org/ii"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

src_prepare() {
	default

	sed -i \
		-e "s/CFLAGS      = -g -O0/CFLAGS += /" \
		-e "s/LDFLAGS     =/LDFLAGS +=/" \
		-e /^LIBS/d \
		config.mk || die

	# enable verbose build
	sed -i 's/@${CC}/${CC}/' Makefile || die

	ht_fix_file query.sh
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ii
	newbin query.sh ii-query
	dodoc CHANGES FAQ README
	doman *.1
}
