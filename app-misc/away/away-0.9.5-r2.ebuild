# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam toolchain-funcs flag-o-matic

DESCRIPTION="Terminal locking program with few additional features"
HOMEPAGE="http://unbeatenpath.net/software/away/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND=">=sys-libs/pam-0.75"
DEPEND="${RDEPEND}"

DOCS=( BUGS AUTHORS NEWS README TODO data/awayrc )
src_prepare() {
	default
	sed -i -e '/-o \$(BINARY)/d' \
		-e 's:LIBS:LDLIBS:' \
		"${S}"/Makefile || die "Makefile fix failed"

}

src_compile() {
	append-flags -pthread

	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin away
	doman doc/*
	einstalldocs
	pamd_mimic_system away auth
}
