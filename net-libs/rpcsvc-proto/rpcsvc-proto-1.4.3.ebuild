# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="rpcsvc protocol definitions from glibc"
HOMEPAGE="https://github.com/thkukuk/rpcsvc-proto"
SRC_URI="https://github.com/thkukuk/rpcsvc-proto/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+ BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="!<sys-libs/glibc-2.26
	virtual/libintl"
# sys-devel/gettext is only for libintl detection macros.
BDEPEND="sys-devel/gettext"

src_prepare() {
	default

	# Use ${CHOST}-cpp, not 'cpp': bug #718138
	# Ideally we should use @CPP@ but rpcgen makes it hard to use '${CHOST}-gcc -E'
	sed -i -s "s/CPP = \"cpp\";/CPP = \"${CHOST}-cpp\";/" rpcgen/rpc_main.c || die
}

src_install() {
	default

	# provided by sys-fs/quota[rpc]
	rm "${ED}"/usr/include/rpcsvc/rquota.{x,h} || die
}
