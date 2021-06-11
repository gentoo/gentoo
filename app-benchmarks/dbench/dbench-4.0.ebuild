# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Popular filesystem benchmark"
SRC_URI="https://www.samba.org/ftp/pub/tridge/dbench/${P}.tar.gz"
HOMEPAGE="https://www.samba.org/ftp/tridge/dbench/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86"

DEPEND="dev-libs/popt"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e "s:\$(CC) -o:\$(CC) \$(LDFLAGS) -o:" Makefile.in || die
	mv configure.{in,ac} || die

	eautoreconf
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin dbench tbench tbench_srv
	dodoc README INSTALL
	doman dbench.1
	insinto /usr/share/dbench
	doins client.txt
}

pkg_postinst() {
	elog "You can find the client.txt file in ${EROOT}/usr/share/dbench."
}
