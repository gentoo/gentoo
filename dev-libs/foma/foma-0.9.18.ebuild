# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A set of utilities for constructing finite-state automata and transducers"
HOMEPAGE="https://github.com/mhulden/foma"
SRC_URI="https://bitbucket.org/mhulden/foma/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="sys-libs/readline:*
	sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/foma-0.9.18-clean-makefile.patch" )

src_prepare() {
	default

	# Install to correct libdir
	sed "s|/lib|/$(get_libdir)|" -i Makefile || die

	append-cflags -fcommon
}

src_compile() {
	export CC="$(tc-getCC)"
	export RANLIB="$(tc-getRANLIB)"

	export CFLAGS="${CFLAGS} -Wl,--as-needed -D_GNU_SOURCE -std=c99 -fvisibility=hidden -fPIC"
	export FLOOKUPLDFLAGS="${LDFLAGS} libfoma.a -lz"
	export LDFLAGS="${LDFLAGS} -lreadline -lz -lncurses"

	default
}

src_install() {
	emake prefix="${D}"/usr install
	einstalldocs
	find "${D}" -name '*.a' -delete || die
}
