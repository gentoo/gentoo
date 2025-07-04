# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Recursive-descent parser generators for C"
HOMEPAGE="https://piumarta.com/software/peg/"
SRC_URI="https://piumarta.com/software/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( ChangeLog README.txt )

src_prepare() {
	default

	sed -i \
		-e '/strip/d' \
		-e '/^CFLAGS/d' \
		-e 's/$(CC) $(CFLAGS) -o/$(CC) $(CFLAGS) $(LDFLAGS) -o/g' \
			Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_test() {
	# There's also a 'check' target but it seems to rely on some
	# data being regenerated (bug #959339).
	emake test \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodir /usr/share/man/man1

	emake \
		ROOT="${D}" \
		PREFIX="${EPREFIX}/usr" \
		MANDIR="${D}/${EPREFIX}/usr/share/man/man1" \
		install
}
