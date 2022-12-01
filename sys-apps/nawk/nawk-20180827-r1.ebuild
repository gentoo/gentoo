# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Brian Kernighan's pattern scanning and processing language"
HOMEPAGE="https://www.cs.princeton.edu/~bwk/btl.mirror/"
SRC_URI="https://github.com/onetrueawk/awk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

DEPEND="
	virtual/yacc
"

S="${WORKDIR}/awk-${PV}"

PATCHES=( "${FILESDIR}/${P}"-parallel-build.patch )

DOCS=( README FIXES )

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
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}
