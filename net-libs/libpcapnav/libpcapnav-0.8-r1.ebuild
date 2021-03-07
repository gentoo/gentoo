# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Libpcap wrapper library to navigate to arbitrary packets in a tcpdump trace file"
HOMEPAGE="http://netdude.sourceforge.net/"
SRC_URI="mirror://sourceforge/netdude/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~sparc x86"
IUSE="doc static-libs"

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"
RESTRICT="test"
DOCS=( AUTHORS ChangeLog README )
PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-noinst_test.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

jer_src_compile() {
	emake SUBDIRS="src docs"
}

src_install() {
	default

	rm -fr "${D}"/usr/share/gtk-doc

	if use doc; then
		docinto html
		dodoc -r docs/*.css docs/html/*.html docs/images
	fi

	find "${ED}" -name '*.la' -delete || die
}
