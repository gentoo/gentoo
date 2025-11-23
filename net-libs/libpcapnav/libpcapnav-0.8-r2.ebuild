# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo

DESCRIPTION="Libpcap wrapper library to navigate to arbitrary packets in a tcpdump trace file"
HOMEPAGE="http://netdude.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/netdude/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"
IUSE="doc static-libs"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-noinst_test.patch
	"${FILESDIR}"/${P}-test-exit-on-failure.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	emake check

	cd test || die
	edo ./run-tests.sh
}

src_install() {
	default

	rm -fr "${ED}"/usr/share/gtk-doc || die

	if use doc; then
		docinto html
		dodoc -r docs/*.css docs/html/*.html docs/images
	fi

	find "${ED}" -name '*.la' -delete || die
}
