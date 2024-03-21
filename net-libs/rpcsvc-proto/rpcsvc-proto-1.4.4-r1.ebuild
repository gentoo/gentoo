# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="rpcsvc protocol definitions from glibc"
HOMEPAGE="https://github.com/thkukuk/rpcsvc-proto"
SRC_URI="https://github.com/thkukuk/rpcsvc-proto/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2.1+ BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	!<sys-libs/glibc-2.26
	virtual/libintl
"
DEPEND="${RDEPEND}"
# sys-devel/gettext is only for libintl detection macros.
BDEPEND="sys-devel/gettext"

src_prepare() {
	default

	# Search for a valid 'cpp' command.
	# The CPP envvar might contain '${CC} -E', which does not work for rpcgen.
	# Bug 718138, 870031, 870061.
	local x cpp=
	for x in {${CHOST}-,}{,clang-}cpp; do
		if cpp="$(type -P "${x}")"; then
			break
		fi
	done
	[[ -n ${cpp} ]] || die "Unable to find cpp"
	sed -i -e "s|CPP = \"/lib/cpp\";|CPP = \"${cpp}\";|" rpcgen/rpc_main.c || die
}

src_install() {
	default

	# provided by sys-fs/quota[rpc]
	rm "${ED}"/usr/include/rpcsvc/rquota.{x,h} || die
}
