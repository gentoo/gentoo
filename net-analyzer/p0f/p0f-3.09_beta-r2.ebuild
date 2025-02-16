# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

MY_P=${P/_beta/b}

DESCRIPTION="A tool to perform passive OS detection based on SYN packets"
HOMEPAGE="https://lcamtuf.coredump.cx/p0f3/"
SRC_URI="https://lcamtuf.coredump.cx/p0f3/releases/${MY_P}.tgz"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-build.patch" )

src_prepare() {
	default

	sed -i -e "/FP_FILE/s:p0f.fp:${EPREFIX}/etc/&:" config.h || die
}

src_compile() {
	tc-export CC

	edo ./build.sh $(use debug && echo debug)

	emake -C tools p0f-client p0f-sendsyn p0f-sendsyn6
}

src_test() {
	./p0f -L || die # check that program starts and can print current interfaces
}

src_install() {
	dosbin p0f tools/p0f-{client,sendsyn,sendsyn6}

	insinto /etc
	doins p0f.fp

	dodoc docs/{ChangeLog,README,TODO,*.txt} tools/README-TOOLS
}
