# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/pdumpfs/pdumpfs-1.3-r2.ebuild,v 1.2 2015/04/19 13:14:35 idella4 Exp $

EAPI=5

inherit eutils

DESCRIPTION="a daily backup system similar to Plan9's dumpfs"
HOMEPAGE="http://0xcc.net/pdumpfs/"
SRC_URI="http://0xcc.net/pdumpfs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="linguas_ja"

DEPEND=">=dev-lang/ruby-2.0.0_p598"

src_prepare() {
	# Bug #509960
	epatch "${FILESDIR}/${PN}-in.patch" \
		"${FILESDIR}/${PN}-test.patch"
}

src_compile() {
	emake pdumpfs
}

src_test() {
	# RUBYOPT=-rauto_gem without rubygems installed will cause ruby to fail, bug #158455 and #163473.
	export RUBYOPT="${GENTOO_RUBYOPT}"
	emake check
}

src_install() {
	dobin pdumpfs

	doman man/man8/pdumpfs.8
	dohtml -r doc/*

	if use linguas_ja; then
		insinto /usr/share/man/ja/man8
		doins man/ja/man8/pdumpfs.8
	fi

	dodoc ChangeLog README
}
