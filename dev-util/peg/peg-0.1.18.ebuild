# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Recursive-descent parser generators for C"
HOMEPAGE="http://piumarta.com/software/peg/"
SRC_URI="http://piumarta.com/software/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	eapply_user

	sed -i \
		-e '/strip/d' \
		-e '/^CFLAGS/d' \
		-e 's/$(CC) $(CFLAGS) -o/$(CC) $(CFLAGS) $(LDFLAGS) -o/g' \
			Makefile || die "sed failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir "/usr/bin"
	emake \
		ROOT="${D}" \
		PREFIX="/usr" \
		install
	rm -rf "${D}/usr/man" || die "rm failed"
	doman src/${PN}.1
}

src_test() {
	emake check test \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}
