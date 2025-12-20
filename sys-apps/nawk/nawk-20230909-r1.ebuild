# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Brian Kernighan's pattern scanning and processing language"
HOMEPAGE="https://www.cs.princeton.edu/~bwk/btl.mirror/"
SRC_URI="https://github.com/onetrueawk/awk/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/awk-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	app-alternatives/yacc
"

DOCS=( README.md FIXES )

PATCHES=(
	"${FILESDIR}"/${PN}-20230909-big-endian.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		HOSTCC="$(tc-getBUILD_CC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS="${CPPFLAGS} -DHAS_ISBLANK" \
		ALLOC="${LDFLAGS}" \
		YACC=$(type -p yacc) \
		YFLAGS="-d -b awkgram"
}

src_install() {
	newbin a.out "${PN}"
	sed \
		-e 's/awk/nawk/g' \
		-e 's/AWK/NAWK/g' \
		-e 's/Awk/Nawk/g' \
		awk.1 > "${PN}".1 || die "manpage patch failed"
	doman "${PN}.1"
	einstalldocs
}
