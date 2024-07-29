# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A utility for solving diff/patch rejects"
HOMEPAGE="http://ftp.suse.com/pub/people/mason/rej/"
SRC_URI="http://ftp.suse.com/pub/people/mason/rej/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-lang/perl
	!<app-editors/mp-5
	!dev-lang/qu-prolog
	!dev-util/mpatch
"

src_test() {
	sh runtests.sh || die
}

src_install() {
	dobin rej qp mp
	dodoc CHANGELOG README vimrc
}
