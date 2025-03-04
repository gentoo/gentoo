# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Recursive-descent parser generators for C"
HOMEPAGE="https://piumarta.com/software/peg/"
# NOTE: Check HOMEPAGE for latest stable version
SRC_URI="https://piumarta.com/software/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( ChangeLog README.txt )

src_prepare() {
	eapply_user

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

src_install() {
	emake \
		ROOT="${D}" \
		PREFIX="/usr" \
		install
	# "reinstall" manpages to a proper location
	rm -r "${D}/usr/man" || die
	doman src/${PN}.1
}

src_test() {
	emake check test \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}
