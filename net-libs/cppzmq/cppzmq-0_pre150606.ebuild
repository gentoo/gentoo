# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/cppzmq/cppzmq-0_pre150606.ebuild,v 1.2 2015/07/10 21:02:59 zerochaos Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="High-level CPP Binding for ZeroMQ"
HOMEPAGE="https://github.com/zeromq/cppzmq"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=net-libs/zeromq-3"
DEPEND=""

src_install() {
	doheader zmq.hpp
	dodoc README
}

src_test() {
	$(tc-getCC) -c ./zmq.hpp -L ./.libs/ -I ./include/ -o ./test.o || die "This version of cppzmq is not compatible with the installed version of net-libs/zeromq"
	rm -f ./test.o
}
