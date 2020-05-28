# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="rpcsvc protocol definitions from glibc"
HOMEPAGE="https://github.com/thkukuk/rpcsvc-proto"
SRC_URI="https://github.com/thkukuk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1+ BSD"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc ~x86"
IUSE=""

# sys-devel/gettext is only for libintl detection macros.
DEPEND="sys-devel/gettext"
RDEPEND="
	!<sys-libs/glibc-2.26
	virtual/libintl
"

src_prepare() {
	default
	eautoreconf

	# Use ${CHOST}-cpp, not 'cpp': bug #718138
	# Ideally we should use @CPP@ but rpcgen makes it hard to use '${CHOST}-gcc -E'
	sed -i -s "s/CPP = \"cpp\";/CPP = \"${CHOST}-cpp\";/" rpcgen/rpc_main.c || die
}

src_install() {
	default

	# provided by sys-fs/quota[rpc]
	rm "${ED}"/usr/include/rpcsvc/rquota.{x,h} || die
}
