# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Brian Kernighan's pattern scanning and processing language"
HOMEPAGE="https://www.cs.princeton.edu/~bwk/btl.mirror/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-macos"

RDEPEND="
	app-eselect/eselect-awk
	!sys-freebsd/freebsd-ubin"

DEPEND="
	${RDEPEND}
	virtual/yacc"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}/${P}"-parallel-build.patch )

DOCS=( README FIXES )

src_prepare() {
	default
	rm -v ytab.[hc] || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CPPFLAGS=-DHAS_ISBLANK \
		ALLOC="${LDFLAGS}" \
		YACC=$(type -p yacc) \
		YFLAGS="-d"
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

pkg_postinst() {
	eselect awk update ifunset
}

pkg_postrm() {
	eselect awk update ifunset
}
