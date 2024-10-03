# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shared Memory Abstraction Library"
HOMEPAGE="https://sr.ht/~nabijaczleweli/ossp"
SRC_URI="https://lfs.nabijaczleweli.xyz/0022-OSSP.org-mirror/ftp.ossp.org/ossp-ftp/pkg/lib/mm/${P}.tar.gz"

LICENSE="mm"
SLOT="1.2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_prepare() {
	default
	sed -i Makefile.in \
		-e '/--mode=link/s| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile.in"
}

src_configure() {
	econf --disable-static
}

src_test() {
	emake test
}

src_install() {
	default
	dodoc PORTING

	# no static archive installed
	find "${D}" -name '*.la' -delete || die
}
