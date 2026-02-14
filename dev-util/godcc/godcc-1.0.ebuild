# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Full-fledged command-line interface to Compiler Explorer instances"
# https://jemarch.net/godcc 404s for now
HOMEPAGE="https://git.sr.ht/~jemarch/godcc"
SRC_URI="https://jemarch.net/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
#KEYWORDS="~amd64"

RDEPEND="dev-libs/boehm-gc"
DEPEND="${RDEPEND}"
# TODO: We will want a pkg_pretend check for whether the active compiler
# supports algol68 once eclass support is there.
BDEPEND="
	sys-devel/gcc[algol68(-)]
"

src_configure() {
	# This hack is needed as flag-o-matic.eclass doesn't yet support
	# Algol 68, WIP.
	export A68FLAGS="${A68FLAGS:--O2} -ftrampoline-impl=heap"

	default
}

src_compile() {
	# Workaround autoconf bug where configure-time A68FLAGS get
	# clobbered to -O2 -g: https://savannah.gnu.org/support/index.php?111382
	#
	# -fno-lto because of -Wlto-type-mismatch with prelude (PR123982)
	emake A68FLAGS="${A68FLAGS} -fno-lto"
}

src_install() {
	default

	dodoc "${FILESDIR}"/godbolt.stunnel
}

pkg_postinst() {
	# https://git.sr.ht/~jemarch/godcc/tree/b49882aec95f56486bc2d08d3c324145c6a8d6c0/item/README.md
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		einfo "Unless running your own Compiler Explorer instance locally,"
		einfo "you will likely need to run a proxy to strip HTTPS. The recommended"
		einfo "setup for this is with net-misc/stunnel."
		einfo ""
		einfo "An example config is installed at ${BROOT}/usr/share/doc/${PF}/godbolt.stunnel,"
		einfo "which can be used as:"
		einfo " # stunnel godbolt.stunnel"
		einfo " $ export GODCC_CEHOST=localhost GODCC_CEPORT=8888"
		einfo " $ godcc ..."
	fi
}
