# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Shared Memory Abstraction Library"
HOMEPAGE="http://www.ossp.org/pkg/lib/mm/"
SRC_URI="ftp://ftp.ossp.org/pkg/lib/mm/${P}.tar.gz"

LICENSE="mm"
SLOT="1.2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

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
