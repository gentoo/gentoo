# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

MY_P=${P/_beta/b}

DESCRIPTION="A tool to perform passive OS detection based on SYN packets"
HOMEPAGE="http://lcamtuf.coredump.cx/p0f3/"
SRC_URI="http://lcamtuf.coredump.cx/p0f3/releases/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos"
IUSE="debug ipv6"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	default

	sed -i \
		-e 's:-g -ggdb::' \
		-e 's:-O3::' \
		-e '/^CC/s:=:?=:' \
		-e '/^CFLAGS/s:=:+=:' \
		-e '/^LDFLAGS/s:=:+=:' \
		build.sh tools/Makefile || die

	sed -i -e "/FP_FILE/s:p0f.fp:${EPREFIX}/etc/&:" config.h || die
}

src_compile() {
	tc-export CC
	./build.sh $(use debug && echo debug) || die
	emake -C tools p0f-client p0f-sendsyn $(use ipv6 && echo p0f-sendsyn6)
}

src_install() {
	dosbin p0f tools/p0f-{client,sendsyn}
	use ipv6 && dosbin tools/p0f-sendsyn6

	insinto /etc
	doins p0f.fp

	dodoc docs/{ChangeLog,README,TODO,*.txt} tools/README-TOOLS
}
